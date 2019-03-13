//
//  MIDStoreCharge.m
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 04/12/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import "MIDStoreCharge.h"
#import "MIDIndomaretPayment.h"
#import "MIDAlfamartPayment.h"
#import "MIDPaymentHelper.h"

@implementation MIDStoreCharge

+ (void)indomaretWithToken:(NSString *)token completion:(void (^)(MIDCStoreResult *_Nullable result, NSError *_Nullable error))completion {
    MIDIndomaretPayment *payment = [MIDIndomaretPayment new];
    [MIDPaymentHelper performPayment:payment token:token completion:^(id _Nullable response, NSError *_Nullable error) {
        if (response) {
            MIDCStoreResult *result = [[MIDCStoreResult alloc] initWithDictionary:response];
            completion(result, nil);
        } else {
            completion(nil, error);
        }
    }];
}

+ (void)alfamartWithToken:(NSString *)token completion:(void (^)(MIDCStoreResult *_Nullable result, NSError *_Nullable error))completion {
    MIDAlfamartPayment *payment = [MIDAlfamartPayment new];
    [MIDPaymentHelper performPayment:payment token:token completion:^(id _Nullable response, NSError *_Nullable error) {
        if (response) {
            MIDCStoreResult *result = [[MIDCStoreResult alloc] initWithDictionary:response];
            completion(result, nil);
        } else {
            completion(nil, error);
        }
    }];
}

@end
