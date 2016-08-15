//
//  VTMerchantClient.m
//  iossdk-gojek
//
//  Created by Akbar Taufiq Herlangga on 3/10/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTMerchantClient.h"
#import "VTConfig.h"
#import "VTNetworking.h"
#import "VTPrivateConfig.h"
#import "VTHelper.h"
#import <MidtransCoreKit/MidtransCoreKit.h>
#import "VTTrackingManager.h"
#import "VTPaymentWebController.h"
#import "TransactionTokenResponse.h"
#import "PaymentRequestDataModels.h"

NSString *const SAVE_MASKEDCARD_URL = @"%@/users/%@/tokens";
NSString *const FETCH_MASKEDCARD_URL = @"%@/users/%@/tokens";
NSString *const CHARGE_TRANSACTION_URL = @"charge";

@interface NSArray (MaskedCard)

- (NSArray *)requestBodyValues;

@end

@implementation NSArray (MaskedCard)

- (NSArray *)requestBodyValues {
    NSMutableArray *parameter = [[NSMutableArray alloc] init];
    for (VTMaskedCreditCard *maskedCard in self) {
        [parameter addObject:maskedCard.dictionaryValue];
    }
    return parameter;
}

@end

@implementation VTMerchantClient

+ (id)sharedClient {
    // Idea stolen from http://www.galloway.me.uk/tutorials/singleton-classes/
    static VTMerchantClient *instance = nil;
    @synchronized(self) {
        if (instance == nil) {
            instance = [[self alloc] init];
        }
    }
    
    return instance;
}

- (void)performTransaction:(VTTransaction *)transaction completion:(void(^)(VTTransactionResult *result, NSError *error))completion {
    
    NSString *URL = [NSString stringWithFormat:@"%@/%@", [PRIVATECONFIG snapURL], [transaction chargeURL]];
    
    NSMutableDictionary *headers = [[NSMutableDictionary alloc] init];
    [headers addEntriesFromDictionary:[CONFIG merchantClientData]];
    [[VTNetworking sharedInstance] postToURL:URL header:headers parameters:[transaction dictionaryValue] callback:^(id response, NSError *error) {
        NSString *paymentType = response[@"payment_type"];
        if (response) {
            VTTransactionResult *chargeResult = [[VTTransactionResult alloc] initWithTransactionResponse:response];
            if ([self isWebPaymentType:paymentType]) {
                NSURL *redirectURL = [NSURL URLWithString:response[@"redirect_url"]];
                VTPaymentWebController *vc = [[VTPaymentWebController alloc] initWithRedirectURL:redirectURL paymentType:paymentType];
                [vc showPageWithCallback:^(NSError * _Nullable error) {
                    if (error) {
                        [[VTTrackingManager sharedInstance]trackTransaction:NO secureProtocol:YES withPaymentFeature:0 paymentMethod:paymentType value:0];
                        if (completion) completion(nil, error);
                    } else {
                        [[VTTrackingManager sharedInstance]trackTransaction:YES secureProtocol:YES withPaymentFeature:0 paymentMethod:paymentType value:0];
                        if (completion) completion(chargeResult, nil);
                    }
                }];
                
            } else if ([paymentType isEqualToString:VT_PAYMENT_CREDIT_CARD]) {
                [[VTTrackingManager sharedInstance]trackTransaction:NO secureProtocol:YES withPaymentFeature:0 paymentMethod:VT_PAYMENT_CREDIT_CARD value:0];
                //transaction finished here
                if (completion) completion(chargeResult, error);
            } else {
                [[VTTrackingManager sharedInstance]trackTransaction:NO secureProtocol:YES withPaymentFeature:0 paymentMethod:paymentType value:0];
                if (completion) completion(chargeResult, error);
            }
        } else {
            [[VTTrackingManager sharedInstance]trackTransaction:NO secureProtocol:YES withPaymentFeature:0 paymentMethod:paymentType value:0];
            if (completion) completion(nil, error);
        }
    }];
}

- (void)saveMaskedCards:(NSArray <VTMaskedCreditCard*>*)maskedCards customer:(VTCustomerDetails *)customer completion:(void(^)(id result, NSError *error))completion {
    NSString *URL = [NSString stringWithFormat:SAVE_MASKEDCARD_URL, [CONFIG merchantURL], customer.customerIdentifier];
    NSArray *parameters = maskedCards.requestBodyValues;
    [[VTNetworking sharedInstance] postToURL:URL header:[CONFIG merchantClientData] parameters:parameters callback:completion];
}

- (void)fetchMaskedCardsCustomer:(VTCustomerDetails *)customer completion:(void(^)(NSArray *maskedCards, NSError *error))completion {
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
                     VTMaskedCreditCard *card = [[VTMaskedCreditCard alloc] initWithDictionary:dictionary];
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
    return [paymentType isEqualToString:VT_PAYMENT_CIMB_CLICKS] ||
    [paymentType isEqualToString:VT_PAYMENT_BCA_KLIKPAY] ||
    [paymentType isEqualToString:VT_PAYMENT_MANDIRI_ECASH] ||
    [paymentType isEqualToString:VT_PAYMENT_BRI_EPAY];
}

- (void)requestTransactionTokenWithTransactionDetails:(nonnull VTTransactionDetails *)transactionDetails
                                          itemDetails:(nullable NSArray<VTItemDetail*> *)itemDetails
                                      customerDetails:(nullable VTCustomerDetails *)customerDetails
                                           completion:(void (^_Nullable)(TransactionTokenResponse *_Nullable token, NSError *_Nullable error))completion
{
    NSMutableDictionary *dictionaryParameters = [NSMutableDictionary new];
    [dictionaryParameters setObject:[transactionDetails dictionaryValue] forKey:VT_CORE_SNAP_PARAMETER_TRANSACTION_DETAILS];
    [dictionaryParameters setObject:[customerDetails dictionaryValue] forKey:VT_CORE_SNAP_PARAMETER_CUSTOMER_DETAILS];
    [dictionaryParameters setObject:[itemDetails itemDetailsDictionaryValue] forKey:VT_CORE_SNAP_PARAMETER_ITEM_DETAILS];
    
    [dictionaryParameters setObject:@{@"save_card":@([CC_CONFIG saveCard])} forKey:@"credit_card"];
    
    if (customerDetails.email.isEmpty || customerDetails.phone.isEmpty || customerDetails.firstName.isEmpty || customerDetails.lastName.isEmpty) {
        if (completion) {
            NSError *error = [[NSError alloc] initWithDomain:VT_ERROR_DOMAIN
                                                        code:513
                                                    userInfo:@{NSLocalizedDescriptionKey:@"Missing customer credentials"}];
            completion(NULL,error);
            return;
        }
        
    }
    else {
        [[VTNetworking sharedInstance] postToURL:[NSString stringWithFormat:@"%@/%@", [CONFIG merchantURL], CHARGE_TRANSACTION_URL]
                                          header:nil
                                      parameters:dictionaryParameters
                                        callback:^(id response, NSError *error) {
                                            if (!error) {
                                                TransactionTokenResponse *token = [TransactionTokenResponse modelObjectWithDictionary:response
                                                                                                                   transactionDetails:transactionDetails
                                                                                                                      customerDetails:customerDetails
                                                                                                                          itemDetails:itemDetails];
                                                if (completion) {
                                                    completion(token,NULL);
                                                }
                                            }
                                            else {
                                                if (completion) {
                                                    completion(NULL,error);
                                                }
                                            }
                                        }];
    }
}

- (void)requestPaymentlistWithToken:(NSString * _Nonnull )token
                         completion:(void (^_Nullable)(PaymentRequestResponse *_Nullable response, NSError *_Nullable error))completion {
    
    [[VTNetworking sharedInstance] getFromURL:[NSString stringWithFormat:@"%@/%@/%@",[PRIVATECONFIG snapURL], ENDPOINT_PAYMENT_PAGES, token] parameters:nil callback:^(id response, NSError *error) {
        if (!error) {
            PaymentRequestResponse *paymentRequest = [[PaymentRequestResponse alloc] initWithDictionary:(NSDictionary *) response];
            
            if (completion) {
                if (!paymentRequest.merchantData.logoUrl.isEmpty) {
                    [VTImageManager getImageFromURLwithUrl:paymentRequest.merchantData.logoUrl];
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
