//
//  VTMerchantClient.m
//  iossdk-gojek
//
//  Created by Akbar Taufiq Herlangga on 3/10/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MTMerchantClient.h"
#import "MTConfig.h"
#import "MTNetworking.h"
#import "MTPrivateConfig.h"
#import "VTHelper.h"
#import <MidtransCoreKit/MidtransCoreKit.h>
#import "MTTrackingManager.h"
#import "MTPaymentWebController.h"
#import "MTTransactionTokenResponse.h"
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
    for (MTMaskedCreditCard *maskedCard in self) {
        [parameter addObject:maskedCard.dictionaryValue];
    }
    return parameter;
}

@end

@implementation MTMerchantClient

+ (id)sharedClient {
    // Idea stolen from http://www.galloway.me.uk/tutorials/singleton-classes/
    static MTMerchantClient *instance = nil;
    @synchronized(self) {
        if (instance == nil) {
            instance = [[self alloc] init];
        }
    }
    
    return instance;
}

- (void)performTransaction:(VTTransaction *)transaction completion:(void(^)(MTTransactionResult *result, NSError *error))completion {
    
    NSString *URL = [NSString stringWithFormat:@"%@/%@", [PRIVATECONFIG snapURL], [transaction chargeURL]];
    
    NSMutableDictionary *headers = [[NSMutableDictionary alloc] init];
    [headers addEntriesFromDictionary:[CONFIG merchantClientData]];
    [[MTNetworking sharedInstance] postToURL:URL header:headers parameters:[transaction dictionaryValue] callback:^(id response, NSError *error) {
        
        NSString *paymentType = transaction.paymentDetails.paymentType;
        
        if (response) {
            MTTransactionResult *chargeResult = [[MTTransactionResult alloc] initWithTransactionResponse:response];
            
            if ([paymentType isEqualToString:MT_PAYMENT_CREDIT_CARD]) {
                [[MTTrackingManager sharedInstance]trackTransaction:YES secureProtocol:YES withPaymentFeature:0 paymentMethod:MT_PAYMENT_CREDIT_CARD value:0];
                //transaction finished here
                if (completion){
                    completion(chargeResult, error);
                }
            }
            else {
                [[MTTrackingManager sharedInstance]trackTransaction:YES secureProtocol:YES withPaymentFeature:0 paymentMethod:paymentType value:0];
                if (completion){
                    completion(chargeResult, error);
                }
            }
        }
        else {
            [[MTTrackingManager sharedInstance]trackTransaction:NO secureProtocol:YES withPaymentFeature:0 paymentMethod:paymentType value:0];
            if (completion) {
                completion(nil, error);
            }
        }
    }];
}

- (void)saveMaskedCards:(NSArray <MTMaskedCreditCard*>*)maskedCards customer:(MTCustomerDetails *)customer completion:(void(^)(id result, NSError *error))completion {
    NSString *URL = [NSString stringWithFormat:SAVE_MASKEDCARD_URL, [CONFIG merchantURL], customer.customerIdentifier];
    NSArray *parameters = maskedCards.requestBodyValues;
    [[MTNetworking sharedInstance] postToURL:URL header:[CONFIG merchantClientData] parameters:parameters callback:completion];
}

- (void)fetchMaskedCardsCustomer:(MTCustomerDetails *)customer completion:(void(^)(NSArray *maskedCards, NSError *error))completion {
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
                     MTMaskedCreditCard *card = [[MTMaskedCreditCard alloc] initWithDictionary:dictionary];
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
    return [paymentType isEqualToString:MT_PAYMENT_CIMB_CLICKS] ||
    [paymentType isEqualToString:MT_PAYMENT_BCA_KLIKPAY] ||
    [paymentType isEqualToString:MT_PAYMENT_MANDIRI_ECASH] ||
    [paymentType isEqualToString:MT_PAYMENT_BRI_EPAY];
}

- (void)requestTransactionTokenWithTransactionDetails:(nonnull VTTransactionDetails *)transactionDetails
                                          itemDetails:(nullable NSArray<MTItemDetail*> *)itemDetails
                                      customerDetails:(nullable MTCustomerDetails *)customerDetails
                                           completion:(void (^_Nullable)(MTTransactionTokenResponse *_Nullable token, NSError *_Nullable error))completion
{
    NSMutableDictionary *dictionaryParameters = [NSMutableDictionary new];
    [dictionaryParameters setObject:[transactionDetails dictionaryValue] forKey:MT_CORE_SNAP_PARAMETER_TRANSACTION_DETAILS];
    [dictionaryParameters setObject:[customerDetails dictionaryValue] forKey:MT_CORE_SNAP_PARAMETER_CUSTOMER_DETAILS];
    [dictionaryParameters setObject:[itemDetails itemDetailsDictionaryValue] forKey:MT_CORE_SNAP_PARAMETER_ITEM_DETAILS];
    
    [dictionaryParameters setObject:@{@"save_card":@([CC_CONFIG saveCard])} forKey:@"credit_card"];
    
    NSError *error;
    if (![customerDetails isValidCustomerData:&error]) {
        if (completion) completion (nil, error);
        return;
    }
    
    [[MTNetworking sharedInstance] postToURL:[NSString stringWithFormat:@"%@/%@", [CONFIG merchantURL], CHARGE_TRANSACTION_URL]
                                      header:nil
                                  parameters:dictionaryParameters
                                    callback:^(id response, NSError *error)
     {
         if (!error) {
             MTTransactionTokenResponse *token = [MTTransactionTokenResponse modelObjectWithDictionary:response
                                                                                transactionDetails:transactionDetails
                                                                                   customerDetails:customerDetails
                                                                                       itemDetails:itemDetails];
             if (completion) {
                 [[MTTrackingManager sharedInstance] trackGeneratedSnapToken:YES];
                 completion(token,NULL);
             }
         }
         else {
             if (completion) {
                 [[MTTrackingManager sharedInstance] trackGeneratedSnapToken:NO];
                 completion(NULL,error);
             }
         }
     }];
    //    }
}

- (void)requestPaymentlistWithToken:(NSString * _Nonnull )token
                         completion:(void (^_Nullable)(MTPaymentRequestResponse *_Nullable response, NSError *_Nullable error))completion {
    
    [[MTNetworking sharedInstance] getFromURL:[NSString stringWithFormat:@"%@/%@/%@",[PRIVATECONFIG snapURL], ENDPOINT_PAYMENT_PAGES, token] parameters:nil callback:^(id response, NSError *error) {
        if (!error) {
            MTPaymentRequestResponse *paymentRequest = [[MTPaymentRequestResponse alloc] initWithDictionary:(NSDictionary *) response];
            
            if (completion) {
                if (!paymentRequest.merchantData.logoUrl.isEmpty) {
                    [MTImageManager getImageFromURLwithUrl:paymentRequest.merchantData.logoUrl];
                    [[NSUserDefaults standardUserDefaults] setObject:paymentRequest.merchantData.merchantName forKey:MT_CORE_MERCHANT_NAME];
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
