//
//  VTConfig.m
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 2/16/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTConfig.h"

NSString *const VTEnvironmentSandbox = @"sandbox";
NSString *const VTEnvironmentProduction = @"production";

@interface VTConfig ()
@property (nonatomic, readwrite) NSString *baseUrl;
@property (nonatomic, readwrite) NSString *clientKey;
@property (nonatomic, readwrite) NSString *merchantServerURL;
@property (nonatomic, readwrite) VTCreditCardFeature creditCardFeature;
@property (nonatomic, readwrite) BOOL secureCreditCardPayment;
@end

@implementation VTConfig

+ (id)sharedInstance {
    static VTConfig *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

+ (void)setMerchantServerURL:(NSString *)merchantServerURL {
    [CONFIG setMerchantServerURL:merchantServerURL];
}

+ (void)setServerEnvironment:(VTServerEnvironment)environment {
    switch (environment) {
        case VTServerEnvironmentProduction:
            [CONFIG setBaseUrl:@"https://api.veritrans.co.id/v2"];
            break;
        case VTServerEnvironmentSandbox:
            [CONFIG setBaseUrl:@"https://api.sandbox.veritrans.co.id/v2"];
            break;
        default:
            break;
    }
}
+ (void)setClientKey:(NSString *)clientKey {
    [CONFIG setClientKey:clientKey];
}
+ (void)setCreditCardPaymentFeature:(VTCreditCardFeature)creditCardFeature {
    [CONFIG setCreditCardFeature:creditCardFeature];
}
+ (void)setCreditCardSecurePayment:(BOOL)secure {
    [CONFIG setSecureCreditCardPayment:secure];
}

@end