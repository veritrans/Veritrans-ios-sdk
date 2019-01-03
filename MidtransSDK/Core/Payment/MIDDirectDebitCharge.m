//
//  MIDDirectDebitCharge.m
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 04/12/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import "MIDDirectDebitCharge.h"
#import "MIDPaymentHelper.h"
#import "MIDWebPayment.h"
#import "MIDMandiriClickpayPayment.h"
#import "MIDClickpayTokenize.h"
#import "MIDKlikbcaPayment.h"

@implementation MIDDirectDebitCharge

+ (void)bcaKlikPayWithToken:(NSString *)token completion:(void (^)(MIDWebPaymentResult * _Nullable, NSError * _Nullable))completion {
    [self payWithToken:token type:MIDWebPaymentTypeBCAKlikPay completion:completion];
}

+ (void)cimbClicksWithToken:(NSString *)token completion:(void (^)(MIDWebPaymentResult * _Nullable, NSError * _Nullable))completion {
    [self payWithToken:token type:MIDWebPaymentTypeCIMBClicks completion:completion];
}

+ (void)briEpayWithToken:(NSString *)token completion:(void (^)(MIDWebPaymentResult * _Nullable, NSError * _Nullable))completion {
    [self payWithToken:token type:MIDWebPaymentTypeBRIEpay completion:completion];
}

+ (void)danamonOnlineWithToken:(NSString *)token completion:(void (^)(MIDWebPaymentResult * _Nullable, NSError * _Nullable))completion {
    [self payWithToken:token type:MIDWebPaymentTypeDanamonOnline completion:completion];
}

+ (void)klikbcaWithToken:(NSString *)token
                  userID:(NSString *)userID
              completion:(void (^)(MIDKlikbcaResult *_Nullable result, NSError *_Nullable error))completion {
    MIDKlikbcaPayment *payment = [[MIDKlikbcaPayment alloc] initWithUserID:userID];
    [MIDPaymentHelper performPayment:payment
                               token:token
                          completion:^(id _Nullable response, NSError *_Nullable error)
     {
         if (response) {
             MIDKlikbcaResult *result = [[MIDKlikbcaResult alloc] initWithDictionary:response];
             completion(result, nil);
         } else {
             completion(nil, error);
         }
     }];
}

+ (void)mandiriClickpayWithToken:(NSString *)snapToken
                      cardNumber:(NSString *)cardNumber
                   clickpayToken:(NSString *)clickpayToken
                      completion:(void (^)(MIDClickpayResult *_Nullable result, NSError *_Nullable error))completion {
    MIDClickpayTokenize *request = [[MIDClickpayTokenize alloc] initWithCardNumber:cardNumber];
    [MIDPaymentHelper getTokenWithRequest:request completion:^(MIDTokenizeResponse *_Nullable token, NSError * _Nullable error) {
        if (token) {
            MIDMandiriClickpayPayment *payment = [[MIDMandiriClickpayPayment alloc] initWithCardToken:token.tokenID
                                                                                        clickpayToken:clickpayToken];
            [MIDPaymentHelper performPayment:payment
                                       token:snapToken
                                  completion:^(id _Nullable response, NSError *_Nullable error)
             {
                 if (response) {
                     MIDClickpayResult *result = [[MIDClickpayResult alloc] initWithDictionary:response];
                     completion(result, nil);
                 } else {
                     completion(nil, error);
                 }
             }];
            
        } else {
            completion(nil, error);
        }
    }];

}

#pragma mark private functions

+ (void)payWithToken:(NSString *)token type:(MIDWebPaymentType)type completion:(void (^)(MIDWebPaymentResult * _Nullable, NSError * _Nullable))completion {
    MIDWebPayment *payment = [[MIDWebPayment alloc] initWithType:type];
    [MIDPaymentHelper performPayment:payment token:token completion:^(id _Nullable response, NSError *_Nullable error) {
        if (response) {
            MIDWebPaymentResult *result = [[MIDWebPaymentResult alloc] initWithDictionary:response];
            completion(result, nil);
        } else {
            completion(nil, error);
        }
    }];
}

@end
