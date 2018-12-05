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

+ (void)mandiriClickpayWithToken:(NSString *)token cardToken:(NSString *)cardToken clickpayToken:(NSString *)clickpayToken completion:(void (^)(__autoreleasing id * _Nullable, NSError * _Nullable))completion {
    MIDMandiriClickpayPayment *payment = [[MIDMandiriClickpayPayment alloc] initWithCardToken:cardToken clickpayToken:clickpayToken];
    [MIDPaymentHelper performPayment:payment token:token completion:^(id _Nullable response, NSError *_Nullable error) {
        if (response) {
//            MIDWebPaymentResult *result = [[MIDWebPaymentResult alloc] initWithDictionary:response];
//            completion(result, nil);
        } else {
//            completion(nil, error);
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
