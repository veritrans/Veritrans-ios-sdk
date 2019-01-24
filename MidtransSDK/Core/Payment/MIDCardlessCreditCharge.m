//
//  MIDCardlessCreditCharge.m
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 24/01/19.
//  Copyright © 2019 Midtrans. All rights reserved.
//

#import "MIDCardlessCreditCharge.h"
#import "MIDPaymentHelper.h"
#import "MIDWebPayment.h"

@implementation MIDCardlessCreditCharge

+ (void)akulakuWithToken:(NSString *)token completion:(void (^)(MIDWebPaymentResult *_Nullable result, NSError *_Nullable error))completion {
    MIDWebPayment *payment = [[MIDWebPayment alloc] initWithType:MIDWebPaymentTypeAkulaku];
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
