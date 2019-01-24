//
//  MIDEWalletCharge.m
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 04/12/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import "MIDEWalletCharge.h"
#import "MIDBankTransferPayment.h"
#import "MIDPaymentHelper.h"
#import "MIDGopayPayment.h"
#import "MIDWebPayment.h"

@implementation MIDEWalletCharge

+ (void)gopayWithToken:(NSString *)token
            completion:(void (^_Nullable) (MIDGopayResult *_Nullable result, NSError *_Nullable error))completion {
    MIDGopayPayment *payment = [MIDGopayPayment new];
    [MIDPaymentHelper performPayment:payment token:token completion:^(id _Nullable response, NSError *_Nullable error) {
        if (response) {
            MIDGopayResult *result = [[MIDGopayResult alloc] initWithDictionary:response];
            completion(result, nil);
        } else {
            completion(nil, error);
        }
    }];
}

+ (void)mandiriECashWithToken:(NSString *)token
                   completion:(void (^_Nullable) (MIDWebPaymentResult *_Nullable result, NSError *_Nullable error))completion {
    MIDWebPayment *payment = [[MIDWebPayment alloc] initWithType:MIDWebPaymentTypeMandiriEcash];
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
