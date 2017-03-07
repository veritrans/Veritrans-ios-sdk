//
//  VTMerchantClient.m
//  iossdk-gojek
//
//  Created by Akbar Taufiq Herlangga on 3/10/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MidtransMerchantClient.h"
#import "MidtransConfig.h"
#import "SNPPointDataModels.h"
#import "MidtransNetworking.h"
#import "MidtransConstant.h"
#import "MidtransPrivateConfig.h"
#import "MidtransHelper.h"
#import "MidtransTrackingManager.h"
#import "MidtransPaymentWebController.h"
#import "MidtransTransactionTokenResponse.h"
#import "MidtransCoreKit.h"

NSString *const SAVE_MASKEDCARD_URL = @"%@/users/%@/tokens";
NSString *const FETCH_MASKEDCARD_URL = @"%@/users/%@/tokens";


@interface NSArray (MaskedCard)

- (NSArray *)requestBodyValues;

@end

@implementation NSArray (MaskedCard)

- (NSArray *)requestBodyValues {
    NSMutableArray *parameter = [[NSMutableArray alloc] init];
    for (MidtransMaskedCreditCard *maskedCard in self) {
        [parameter addObject:maskedCard.dictionaryValue];
    }
    return parameter;
}

@end

@implementation MidtransMerchantClient

+ (MidtransMerchantClient *)shared {
    static MidtransMerchantClient *instance = nil;
    @synchronized(self) {
        if (instance == nil) {
            instance = [[self alloc] init];
        }
    }
    
    return instance;
}

- (void)performTransaction:(MidtransTransaction *)transaction
                completion:(void(^)(MidtransTransactionResult *result, NSError *error))completion {
    
    NSMutableDictionary *headers = [[NSMutableDictionary alloc] init];
    [headers addEntriesFromDictionary:[CONFIG merchantClientData]];
    [[MidtransNetworking shared] postToURL:[transaction chargeURL] header:headers parameters:[transaction dictionaryValue] callback:^(id response, NSError *error) {
        
        NSString *paymentType = transaction.paymentType;
        
        if (response) {
            MidtransTransactionResult *chargeResult = [[MidtransTransactionResult alloc] initWithTransactionResponse:response];
            if ([paymentType isEqualToString:MIDTRANS_PAYMENT_CREDIT_CARD]) {
                [[MidtransTrackingManager shared]trackTransaction:YES secureProtocol:YES withPaymentFeature:0 paymentMethod:MIDTRANS_PAYMENT_CREDIT_CARD value:0];
                if (completion){
                    completion(chargeResult, error);
                }
            }
            else {
                [[MidtransTrackingManager shared]trackTransaction:YES secureProtocol:YES withPaymentFeature:0 paymentMethod:paymentType value:0];
                if (completion){
                    completion(chargeResult, error);
                }
            }
        }
        else {
            [[MidtransTrackingManager shared]trackTransaction:NO secureProtocol:YES withPaymentFeature:0 paymentMethod:paymentType value:0];
            if (completion) {
                completion(nil, error);
            }
        }
    }];
}

- (void)deleteMaskedCreditCard:(MidtransMaskedCreditCard *)maskedCard
                         token:(MidtransTransactionTokenResponse *)token
                    completion:(void(^)(BOOL success))completion {
    NSString *stringURL = [NSString stringWithFormat:@"%@/transactions/%@/saved_tokens/%@",PRIVATECONFIG.snapURL, token.tokenId, maskedCard.maskedNumber];
    NSDictionary *parameter = @{@"token":token.tokenId,
                                @"masked_card":maskedCard.maskedNumber};
    [[MidtransNetworking shared] deleteFromURL:stringURL header:nil parameters:parameter callback:^(id response, NSError *error) {
        BOOL success = YES;
        if (error) {
            success = NO;
        }
        if (response[@"error_message"]) {
            success = NO;
        }
        if (completion) completion(success);
    }];
}

- (void)saveMaskedCards:(NSArray <MidtransPaymentCreditCard*>*)maskedCards
               customer:(MidtransCustomerDetails *)customer
             completion:(void(^)(id result, NSError *error))completion {
    NSString *URL = [NSString stringWithFormat:SAVE_MASKEDCARD_URL, [CONFIG merchantURL], customer.customerIdentifier];
    NSArray *parameters = maskedCards.requestBodyValues;
    [[MidtransNetworking shared] postToURL:URL header:[CONFIG merchantClientData] parameters:parameters callback:completion];
}

- (void)fetchMaskedCardsCustomer:(MidtransCustomerDetails *)customer completion:(void(^)(NSArray *maskedCards, NSError *error))completion {
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:FETCH_MASKEDCARD_URL, [CONFIG merchantURL], customer.customerIdentifier]];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (data) {
             NSMutableArray *result = [[NSMutableArray alloc] init];
             NSError *error;
             id requestResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
             
             if (!error) {
                 for (NSDictionary *dictionary in requestResponse) {
                     MidtransMaskedCreditCard *card = [[MidtransMaskedCreditCard alloc] initWithDictionary:dictionary];
                     [result addObject:card];
                 }
             }
             
             if (completion) completion(result, nil);
         }
         else {
             if (completion) completion(nil, error);
         }
     }];
}

#pragma mark - Helper

- (BOOL)isWebPaymentType:(NSString *)paymentType {
    return [paymentType isEqualToString:MIDTRANS_PAYMENT_CIMB_CLICKS] ||
    [paymentType isEqualToString:MIDTRANS_PAYMENT_BCA_KLIKPAY] ||
    [paymentType isEqualToString:MIDTRANS_PAYMENT_MANDIRI_ECASH] ||
    [paymentType isEqualToString:MIDTRANS_PAYMENT_BRI_EPAY];
}
- (void)requestCustomerPointWithToken:(NSString * _Nonnull )token
                   andCreditCardToken:(NSString *_Nonnull)creditCardToken
                           completion:(void (^_Nullable)(SNPPointResponse *_Nullable response, NSError *_Nullable error))completion {
    NSString *stringURL = [NSString stringWithFormat:@"%@/transactions/%@/point_inquiry/%@",PRIVATECONFIG.snapURL, token, creditCardToken];
    [[MidtransNetworking shared] getFromURL:stringURL parameters:nil callback:^(id response, NSError *error) {
        if (!error) {
            SNPPointResponse *pointResponse = [[SNPPointResponse alloc] initWithDictionary:(NSDictionary *)response];
            if (completion) {
                completion(pointResponse,NULL);
            }
        }
        else{
            if (completion) {
                [[MidtransTrackingManager shared] trackGeneratedSnapToken:NO];
                completion(NULL,error);
            }
        }
    }];

}
- (void)requestTransactionTokenWithTransactionDetails:(nonnull MidtransTransactionDetails *)transactionDetails
                                          itemDetails:(nullable NSArray<MidtransItemDetail*> *)itemDetails
                                      customerDetails:(nullable MidtransCustomerDetails *)customerDetails
                                          customField:(nullable NSArray *)customField
                                transactionExpireTime:(MidtransTransactionExpire *)expireTime
                                           completion:(void (^_Nullable)(MidtransTransactionTokenResponse *_Nullable token, NSError *_Nullable error))completion {
    NSMutableDictionary *dictionaryParameters = [NSMutableDictionary new];
    [dictionaryParameters setObject:[transactionDetails dictionaryValue] forKey:MIDTRANS_CORE_SNAP_PARAMETER_TRANSACTION_DETAILS];
    [dictionaryParameters setObject:[customerDetails dictionaryValue] forKey:MIDTRANS_CORE_SNAP_PARAMETER_CUSTOMER_DETAILS];
    [dictionaryParameters setObject:[itemDetails itemDetailsDictionaryValue] forKey:MIDTRANS_CORE_SNAP_PARAMETER_ITEM_DETAILS];
    [dictionaryParameters setObject:customerDetails.customerIdentifier forKey:@"user_id"];
    if ([customField count] || [customField isEqual:[NSNull null]]) {
        for (NSDictionary *dictionary in customField) {
            NSArray *key_dictionary=[dictionary allKeys];
            for (NSString *string_key in key_dictionary) {
                [dictionaryParameters setObject:[dictionary objectForKey:string_key] forKey:string_key];

            }
            
        }
    }
    if ([[expireTime dictionaryRepresentation] count] || [expireTime isEqual:[NSNull null]]) {
        [dictionaryParameters setObject:[expireTime dictionaryRepresentation] forKey:MIDTRANS_CORE_SNAP_PARAMETER_EXPIRE_TIME];
    }
    
    NSMutableDictionary *creditCardParameter = [NSMutableDictionary new];
    [creditCardParameter setObject:@(CC_CONFIG.saveCardEnabled) forKey:@"save_card"];
    [creditCardParameter setObject:@(CC_CONFIG.secureSnapEnabled) forKey:@"secure"];
    if (CC_CONFIG.acquiringBankString) {
        creditCardParameter[@"bank"] = CC_CONFIG.acquiringBankString;
    }
    if (CC_CONFIG.preauthEnabled) {
        creditCardParameter[@"type"] = @"authorize";
    }
    [dictionaryParameters setObject:creditCardParameter forKey:@"credit_card"];
    
    NSError *error;
    if (![customerDetails isValidCustomerData:&error]) {
        if (completion) completion (nil, error);
        return;
    }
    
    NSString *URL = [NSString stringWithFormat:@"%@/%@", [CONFIG merchantURL], MIDTRANS_CORE_SNAP_MERCHANT_SERVER_CHARGE];
    
    if (CC_CONFIG.promoEnabled) {
        NSMutableDictionary *promoParam = [NSMutableDictionary new];
        promoParam[@"enabled"] = @"YES";
        if (CC_CONFIG.allowedPromoCodes) {
            promoParam[@"allowed_promo_codes"] = CC_CONFIG.allowedPromoCodes;
        }
        dictionaryParameters[@"promo"] = promoParam;
    }
    
    [[MidtransNetworking shared] postToURL:URL
                                    header:nil
                                parameters:dictionaryParameters
                                  callback:^(id response, NSError *error)
     {
         if (!error) {
             
             MidtransTransactionTokenResponse *token = [MidtransTransactionTokenResponse modelObjectWithDictionary:(NSDictionary *)response
                                                                                                transactionDetails:transactionDetails
                                                                                                   customerDetails:customerDetails
                                                                                                       itemDetails:itemDetails];
             if (completion) {
                 [[MidtransTrackingManager shared] trackGeneratedSnapToken:YES];
                 completion(token,NULL);
             }
         }
         else {
             if (completion) {
                 [[MidtransTrackingManager shared] trackGeneratedSnapToken:NO];
                 completion(NULL,error);
             }
         }
     }];
    
    
}
- (void)requestTransactionTokenWithTransactionDetails:(nonnull MidtransTransactionDetails *)transactionDetails
                                          itemDetails:(nullable NSArray<MidtransItemDetail*> *)itemDetails
                                      customerDetails:(nullable MidtransCustomerDetails *)customerDetails
                                           completion:(void (^_Nullable)(MidtransTransactionTokenResponse *_Nullable token, NSError *_Nullable error))completion {
    [self requestTransactionTokenWithTransactionDetails:transactionDetails itemDetails:itemDetails customerDetails:customerDetails customField:nil transactionExpireTime:nil completion:completion];
}

- (void)requestPaymentlistWithToken:(NSString * _Nonnull )token
                         completion:(void (^_Nullable)(MidtransPaymentRequestV2Response *_Nullable response, NSError *_Nullable error))completion {
    NSString *URL = [NSString stringWithFormat:ENDPOINT_TRANSACTION_DETAIL, [PRIVATECONFIG snapURL], token];
    [[MidtransNetworking shared] getFromURL:URL parameters:nil callback:^(id response, NSError *error) {
        if (!error) {
            MidtransPaymentRequestV2Response *paymentRequestV2 = [[MidtransPaymentRequestV2Response alloc] initWithDictionary:(NSDictionary *)response];
            
            if (completion) {
                if ([[paymentRequestV2.merchant.preference dictionaryRepresentation] count]) {
                    [MidtransImageManager getImageFromURLwithUrl:paymentRequestV2.merchant.preference.logoUrl];
                    [[NSUserDefaults standardUserDefaults] setObject:paymentRequestV2.merchant.preference.displayName forKey:MIDTRANS_CORE_MERCHANT_NAME];
                    [[NSUserDefaults standardUserDefaults] setObject:token forKey:MIDTRANS_CORE_SAVED_ID_TOKEN];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
                [[MidtransTrackingManager shared] trackGeneratedSnapToken:YES];
                completion(paymentRequestV2,NULL);
            }
        }
        else{
            if (completion) {
                [[MidtransTrackingManager shared] trackGeneratedSnapToken:NO];
                completion(NULL,error);
            }
        }
    }];
}

@end
