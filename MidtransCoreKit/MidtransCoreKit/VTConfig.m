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
@end

@implementation VTConfig

@synthesize merchantAuth = _merchantAuth;

- (NSString *)merchantServerURL {
    NSAssert(_merchantServerURL, @"please include your merchant server URL in VTConfig");
    return _merchantServerURL;
}

- (NSString *)clientKey {
    NSAssert(_clientKey, @"please include the Client Key in VTConfig");
    return _clientKey;
}

- (VTMerchantAuth *)merchantAuth {
    NSData *encoded = [[NSUserDefaults standardUserDefaults] objectForKey:@"vt_merchant_auth"];
    if (encoded) {
        _merchantAuth = [NSKeyedUnarchiver unarchiveObjectWithData:encoded];
    }
    return _merchantAuth;
}

- (void)setMerchantAuth:(VTMerchantAuth *)merchantAuth {
    _merchantAuth = merchantAuth;
    
    NSData *encoded = [NSKeyedArchiver archivedDataWithRootObject:merchantAuth];
    [[NSUserDefaults standardUserDefaults] setObject:encoded forKey:@"vt_merchant_auth"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+ (id)sharedInstance {
    static VTConfig *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

- (void)setEnvironment:(VTServerEnvironment)environment {
    _environment = environment;
    
    switch (environment) {
        case VTServerEnvironmentProduction:
            self.baseUrl = @"https://api.veritrans.co.id/v2";
            break;
        case VTServerEnvironmentSandbox:
            self.baseUrl = @"https://api.sandbox.veritrans.co.id/v2";
            break;
        default:
            break;
    }
}

@end