//
//  MIDPaymentHelper.m
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 03/12/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import "MIDPaymentHelper.h"
#import "MIDVendor.h"
#import "MIDNetworkService.h"
#import "MIDNetwork.h"
#import "MIDNetworkHelper.h"

@implementation MIDPaymentHelper

+ (void)performPayment:(NSObject<MIDPayable> *)payment
                 token:(NSString *)token
            completion:(void (^)(id _Nullable response, NSError *_Nullable error))completion {
    NSString *path = [NSString stringWithFormat:@"/transactions/%@/pay", token];
    MIDNetworkService *service = [[MIDNetworkService alloc] initWithBaseURL:[MIDVendor shared].snapURL
                                                                       path:path
                                                                     method:MIDNetworkMethodPOST
                                                                 parameters:payment.dictionaryValue];
    [[MIDNetwork shared] request:service completion:^(id  _Nullable response, NSError *_Nullable error) {
        if (response) {
            completion(response, nil);
        } else {
            completion(nil, error);
        }
    }];
}

+ (void)getTokenWithRequest:(NSObject <MIDTokenizable> *)request
                 completion:(void (^)(MIDTokenizeResponse *_Nullable token, NSError *_Nullable error))completion {
    NSString *path = @"token";
    MIDNetworkService *service = [[MIDNetworkService alloc] initWithBaseURL:[MIDVendor shared].midtransURL
                                                                       path:path
                                                                     method:MIDNetworkMethodGET
                                                                 parameters:request.dictionaryValue];
    [[MIDNetwork shared] request:service completion:^(id  _Nullable response, NSError *_Nullable error) {
        if (response) {
            MIDTokenizeResponse *result = [[MIDTokenizeResponse alloc] initWithDictionary:response];
            completion(result, nil);
        } else {
            completion(nil, error);
        }
    }];
}

@end
