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
    
    NSString *URL = [NSString stringWithFormat:@"%@/%@", [PRIVATECONFIG snapURL],@"pay"];
    
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
                
                //save token to merchant server
                //i'm not set callback until save card finished because save card is optional
                BOOL isSavedToken = response[@"saved_token_id"] != nil;
                if (isSavedToken) {
                    VTMaskedCreditCard *savedCard = [[VTMaskedCreditCard alloc] initWithData:response];
                    [self saveRegisteredCard:savedCard completion:nil];
                }
                
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

- (void)saveRegisteredCard:(VTMaskedCreditCard *)savedCard completion:(void(^)(id result, NSError *error))completion {
    //    NSString *URL = [NSString stringWithFormat:@"%@/%@", [CONFIG merchantServerURL], @"card/register"];
    //    [[VTNetworking sharedInstance] postToURL:URL header:[CONFIG merchantClientData] parameters:savedCard.dictionaryValue callback:completion];
}

- (void)fetchMaskedCardsWithCompletion:(void(^)(NSArray *maskedCards, NSError *error))completion {
    //    NSString *URL = [NSString stringWithFormat:@"%@/%@", [CONFIG merchantServerURL], @"card"];
    //    [[VTNetworking sharedInstance] getFromURL:URL header:[CONFIG merchantClientData]  parameters:nil callback:^(id response, NSError *error) {
    //
    //        NSMutableArray *result;
    //        if (response) {
    //            result = [NSMutableArray new];
    //            NSArray *rawCards = response[@"data"];
    //            for (id rawCard in rawCards) {
    //                VTMaskedCreditCard *card = [[VTMaskedCreditCard alloc] initWithData:rawCard];
    //                [result addObject:card];
    //            }
    //        }
    //        if (completion) completion(result, error);
    //
    //    }];
}

- (void)deleteMaskedCard:(VTMaskedCreditCard *)maskedCard completion:(void(^)(BOOL success, NSError *error))completion {
    //    NSString *URL = [NSString stringWithFormat:@"%@/%@/%@", [CONFIG merchantServerURL], @"card", maskedCard.savedTokenId];
    //    [[VTNetworking sharedInstance] deleteFromURL:URL header:[CONFIG merchantClientData] parameters:nil callback:^(id response, NSError *error) {
    //        if (response) {
    //            if (completion) completion(true, error);
    //        } else {
    //            if (completion) completion(false, error);
    //        }
    //    }];
}

- (void)fetchMerchantAuthDataWithCompletion:(void(^)(id response, NSError *error))completion {
    //    NSString *URL = [NSString stringWithFormat:@"%@/auth", [CONFIG merchantServerURL]];
    //    [[VTNetworking sharedInstance] postToURL:URL parameters:nil callback:completion];
}

#pragma mark - Helper

- (BOOL)isWebPaymentType:(NSString *)paymentType {
    return [paymentType isEqualToString:VT_PAYMENT_CIMB_CLICKS] ||
    [paymentType isEqualToString:VT_PAYMENT_BCA_KLIKPAY] ||
    [paymentType isEqualToString:VT_PAYMENT_MANDIRI_ECASH] ||
    [paymentType isEqualToString:VT_PAYMENT_BRI_EPAY];
}

- (void)requestTransactionTokenWithclientTokenURL:(nonnull NSURL*)clientTokenUrl
                               transactionDetails:(nonnull VTTransactionDetails *)transactionDetails
                                      itemDetails:(nullable NSArray<VTItemDetail*> *)itemDetails
                                  customerDetails:(nullable VTCustomerDetails *)customerDetails
                          customerCreditCardToken:(nullable NSString *)creditCardToken
                                       completion:(void (^_Nullable)(TransactionTokenResponse *_Nullable token, NSError *_Nullable error))completion {
    NSMutableDictionary *dictionaryParameters = [NSMutableDictionary new];
    [dictionaryParameters setObject:[transactionDetails dictionaryValue] forKey:VT_CORE_SNAP_PARAMETER_TRANSACTION_DETAILS];
    
    [[VTNetworking sharedInstance] postToURL:[NSString stringWithFormat:@"%@",clientTokenUrl]
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
- (void)requestPaymentlistWithToken:(NSString * _Nonnull )token
                         completion:(void (^_Nullable)(PaymentRequestResponse *_Nullable response, NSError *_Nullable error))completion {
    
    [[VTNetworking sharedInstance] getFromURL:[NSString stringWithFormat:@"%@/%@",[PRIVATECONFIG snapURL],token] parameters:nil callback:^(id response, NSError *error) {
        if (!error) {
            PaymentRequestResponse *paymentRequest = [[PaymentRequestResponse alloc] initWithDictionary:(NSDictionary *) response];
            if (completion) {
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
