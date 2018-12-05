//
//  MIDStoreCharge.m
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 04/12/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import "MIDStoreCharge.h"
#import "MIDIndomaretPayment.h"
#import "MIDPaymentHelper.h"

@implementation MIDStoreCharge

+ (void)indomaretWithToken:(NSString *)token completion:(void (^)(MIDIndomaretResult * _Nullable, NSError * _Nullable))completion {
    MIDIndomaretPayment *payment = [MIDIndomaretPayment new];
    [MIDPaymentHelper performPayment:payment token:token completion:^(id _Nullable response, NSError *_Nullable error) {
        if (response) {
            MIDIndomaretResult *result = [[MIDIndomaretResult alloc] initWithDictionary:response];
            completion(result, nil);
        } else {
            completion(nil, error);
        }
    }];
}

@end
