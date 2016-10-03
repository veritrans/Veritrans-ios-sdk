//
//  VTMerchantClient.m
//  iossdk-gojek
//
//  Created by Akbar Taufiq Herlangga on 3/10/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MidtransMerchantClient.h"
#import "MidtransConfig.h"
#import "MidtransNetworking.h"
#import "MidtransPrivateConfig.h"
#import "MidtransHelper.h"
#import <MidtransCoreKit/MidtransCoreKit.h>
#import "MidtransTrackingManager.h"
#import "MidtransPaymentWebController.h"
#import "MidtransTransactionTokenResponse.h"
#import "MTPaymentRequestDataModels.h"

NSString *const SAVE_MASKEDCARD_URL = @"%@/users/%@/tokens";
NSString *const FETCH_MASKEDCARD_URL = @"%@/users/%@/tokens";
NSString *const CHARGE_TRANSACTION_URL = @"charge";

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

+ (id)sharedClient {
    // Idea stolen from http://www.galloway.me.uk/tutorials/singleton-classes/
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
    
    NSString *URL = [NSString stringWithFormat:@"%@/%@", [PRIVATECONFIG snapURL], [transaction chargeURL]];
    
    NSMutableDictionary *headers = [[NSMutableDictionary alloc] init];
    [headers addEntriesFromDictionary:[CONFIG merchantClientData]];
    [[MidtransNetworking sharedInstance] postToURL:URL header:headers parameters:[transaction dictionaryValue] callback:^(id response, NSError *error) {
        
        NSString *paymentType = transaction.paymentType;
        
        if (response) {
            MidtransTransactionResult *chargeResult = [[MidtransTransactionResult alloc] initWithTransactionResponse:response];
            
            if ([paymentType isEqualToString:MIDTRANS_PAYMENT_CREDIT_CARD]) {
                [[MidtransTrackingManager sharedInstance]trackTransaction:YES secureProtocol:YES withPaymentFeature:0 paymentMethod:MIDTRANS_PAYMENT_CREDIT_CARD value:0];
                //transaction finished here
                if (completion){
                    completion(chargeResult, error);
                }
            }
            else {
                [[MidtransTrackingManager sharedInstance]trackTransaction:YES secureProtocol:YES withPaymentFeature:0 paymentMethod:paymentType value:0];
                if (completion){
                    completion(chargeResult, error);
                }
            }
        }
        else {
            [[MidtransTrackingManager sharedInstance]trackTransaction:NO secureProtocol:YES withPaymentFeature:0 paymentMethod:paymentType value:0];
            if (completion) {
                completion(nil, error);
            }
        }
    }];
}

- (void)saveMaskedCards:(NSArray <MidtransPaymentCreditCard*>*)maskedCards
               customer:(MidtransCustomerDetails *)customer
             completion:(void(^)(id result, NSError *error))completion {
    NSString *URL = [NSString stringWithFormat:SAVE_MASKEDCARD_URL, [CONFIG merchantURL], customer.customerIdentifier];
    NSArray *parameters = maskedCards.requestBodyValues;
    [[MidtransNetworking sharedInstance] postToURL:URL header:[CONFIG merchantClientData] parameters:parameters callback:completion];
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

- (void)requestTransactionTokenWithTransactionDetails:(nonnull MidtransTransactionDetails *)transactionDetails
                                          itemDetails:(nullable NSArray<MidtransItemDetail*> *)itemDetails
                                      customerDetails:(nullable MidtransCustomerDetails *)customerDetails
                                           completion:(void (^_Nullable)(MidtransTransactionTokenResponse *_Nullable token, NSError *_Nullable error))completion
{
    NSMutableDictionary *dictionaryParameters = [NSMutableDictionary new];
    [dictionaryParameters setObject:[transactionDetails dictionaryValue] forKey:MIDTRANS_CORE_SNAP_PARAMETER_TRANSACTION_DETAILS];
    [dictionaryParameters setObject:[customerDetails dictionaryValue] forKey:MIDTRANS_CORE_SNAP_PARAMETER_CUSTOMER_DETAILS];
    [dictionaryParameters setObject:[itemDetails itemDetailsDictionaryValue] forKey:MIDTRANS_CORE_SNAP_PARAMETER_ITEM_DETAILS];
    
    [dictionaryParameters setObject:@{@"save_card":@([CC_CONFIG saveCard])} forKey:@"credit_card"];
    
    NSError *error;
    if (![customerDetails isValidCustomerData:&error]) {
        if (completion) completion (nil, error);
        return;
    }
    
    [[MidtransNetworking sharedInstance] postToURL:[NSString stringWithFormat:@"%@/%@", [CONFIG merchantURL], CHARGE_TRANSACTION_URL]
                                            header:nil
                                        parameters:dictionaryParameters
                                          callback:^(id response, NSError *error)
     {
         if (!error) {
             MidtransTransactionTokenResponse *token = [MidtransTransactionTokenResponse modelObjectWithDictionary:response
                                                                                                transactionDetails:transactionDetails
                                                                                                   customerDetails:customerDetails
                                                                                                       itemDetails:itemDetails];
             if (completion) {
                 [[MidtransTrackingManager sharedInstance] trackGeneratedSnapToken:YES];
                 completion(token,NULL);
             }
         }
         else {
             if (completion) {
                 [[MidtransTrackingManager sharedInstance] trackGeneratedSnapToken:NO];
                 completion(NULL,error);
             }
         }
     }];
}

- (void)requestPaymentlistWithToken:(NSString * _Nonnull )token
                         completion:(void (^_Nullable)(MidtransPaymentRequestResponse *_Nullable response, NSError *_Nullable error))completion {
    
    [[MidtransNetworking sharedInstance] getFromURL:[NSString stringWithFormat:@"%@/%@/%@",[PRIVATECONFIG snapURL], ENDPOINT_PAYMENT_PAGES, token] parameters:nil callback:^(id response, NSError *error) {
        if (!error) {
            MidtransPaymentRequestResponse *paymentRequest = [[MidtransPaymentRequestResponse alloc] initWithDictionary:(NSDictionary *) response];
            
            if (completion) {
                if (!paymentRequest.merchantData.logoUrl.isEmpty) {
                    [MidtransImageManager getImageFromURLwithUrl:paymentRequest.merchantData.logoUrl];
                    [[NSUserDefaults standardUserDefaults] setObject:paymentRequest.merchantData.merchantName forKey:MIDTRANS_CORE_MERCHANT_NAME];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
                completion(paymentRequest,NULL);
            }
        }
        else{
            if (completion) {
                completion(NULL,error);
            }
        }
    }];
}

@end
