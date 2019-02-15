//
//  MIDPayment.m
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 03/12/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import "MIDBankTransferCharge.h"
#import "MIDBankTransferPayment.h"
#import "MIDPaymentHelper.h"

@implementation MIDBankTransferCharge

+ (void)bcaWithToken:(NSString *)token
                name:(NSString *_Nullable)name
               email:(NSString *_Nullable)email
               phone:(NSString *_Nullable)phone
          completion:(void (^_Nullable) (MIDBCABankTransferResult *_Nullable result, NSError *_Nullable error))completion {
    MIDBankTransferPayment *payment = [[MIDBankTransferPayment alloc] initWithType:MIDBankTransferTypeBCA email:email];
    [MIDPaymentHelper performPayment:payment token:token completion:^(id _Nullable response, NSError *_Nullable error) {
        if (response) {
            MIDBCABankTransferResult *result = [[MIDBCABankTransferResult alloc] initWithDictionary:response];
            completion(result, nil);
        } else {
            completion(nil, error);
        }
    }];
}

+ (void)permataWithToken:(NSString *)token
                    name:(NSString *_Nullable)name
                   email:(NSString *_Nullable)email
                   phone:(NSString *_Nullable)phone
              completion:(void (^_Nullable) (MIDPermataBankTransferResult *_Nullable result, NSError *_Nullable error))completion {
    MIDBankTransferPayment *payment = [[MIDBankTransferPayment alloc] initWithType:MIDBankTransferTypePermata email:email];
    [MIDPaymentHelper performPayment:payment token:token completion:^(id _Nullable response, NSError *_Nullable error) {
        if (response) {
            MIDPermataBankTransferResult *result = [[MIDPermataBankTransferResult alloc] initWithDictionary:response];
            completion(result, nil);
        } else {
            completion(nil, error);
        }
    }];
}

+ (void)mandiriWithToken:(NSString *)token
                    name:(NSString *_Nullable)name
                   email:(NSString *_Nullable)email
                   phone:(NSString *_Nullable)phone
              completion:(void (^_Nullable) (MIDMandiriBankTransferResult *_Nullable result, NSError *_Nullable error))completion {
    MIDBankTransferPayment *payment = [[MIDBankTransferPayment alloc] initWithType:MIDBankTransferTypeEchannel email:email];
    [MIDPaymentHelper performPayment:payment token:token completion:^(id _Nullable response, NSError *_Nullable error) {
        if (response) {
            MIDMandiriBankTransferResult *result = [[MIDMandiriBankTransferResult alloc] initWithDictionary:response];
            completion(result, nil);
        } else {
            completion(nil, error);
        }
    }];
}

+ (void)bniWithToken:(NSString *)token
                name:(NSString *_Nullable)name
               email:(NSString *_Nullable)email
               phone:(NSString *_Nullable)phone
          completion:(void (^_Nullable) (MIDBNIBankTransferResult *_Nullable result, NSError *_Nullable error))completion {
    MIDBankTransferPayment *payment = [[MIDBankTransferPayment alloc] initWithType:MIDBankTransferTypeBNI email:email];
    [MIDPaymentHelper performPayment:payment token:token completion:^(id _Nullable response, NSError *_Nullable error) {
        if (response) {
            MIDBNIBankTransferResult *result = [[MIDBNIBankTransferResult alloc] initWithDictionary:response];
            completion(result, nil);
        } else {
            completion(nil, error);
        }
    }];
}

+ (void)otherBankWithToken:(NSString *)token
                      name:(NSString *_Nullable)name
                     email:(NSString *_Nullable)email
                     phone:(NSString *_Nullable)phone
                completion:(void (^_Nullable) (id _Nullable result, NSError *_Nullable error))completion {
    MIDBankTransferPayment *payment = [[MIDBankTransferPayment alloc] initWithType:MIDBankTransferTypeOther email:email];
    [MIDPaymentHelper performPayment:payment token:token completion:^(id _Nullable response, NSError *_Nullable error) {
        if (response) {
            completion(response, nil);
        } else {
            completion(nil, error);
        }
    }];
}

@end
