//
//  MTPrivateConfig.m
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 5/31/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MTPrivateConfig.h"
#import "MTConstant.h"
@interface MTPrivateConfig()
@property (nonatomic) NSString *baseUrl;
@property (nonatomic) NSString *mixpanelToken;
@property (nonatomic) NSString *snapURL;
@end

@implementation MTPrivateConfig

+ (id)sharedInstance {
    static MTPrivateConfig *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

+ (void)setServerEnvironment:(MTServerEnvironment)environment {
    
    if (environment == MTServerEnvironmentProduction) {
        [[MTPrivateConfig sharedInstance] setBaseUrl: MT_PRODUCTION_API_URL];
        [[MTPrivateConfig sharedInstance] setMixpanelToken: MT_PRODUCTION_MIXPANEL];
        [[MTPrivateConfig sharedInstance] setSnapURL: MT_PROD_SNAP];
    } else {
        [[MTPrivateConfig sharedInstance] setBaseUrl: MT_SANDBOX_API_URL];
        [[MTPrivateConfig sharedInstance] setMixpanelToken:MT_SANDBOX_MIXPANEL];
        [[MTPrivateConfig sharedInstance] setSnapURL: MT_SANDBOX_SNAP];
    }
    
}
@end
