//
//  VTPrivateConfig.m
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 5/31/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MidtransPrivateConfig.h"
#import "VTConstant.h"
@interface MidtransPrivateConfig()
@property (nonatomic) NSString *baseUrl;
@property (nonatomic) NSString *mixpanelToken;
@property (nonatomic) NSString *snapURL;
@end

@implementation MidtransPrivateConfig

+ (id)sharedInstance {
    static MidtransPrivateConfig *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

+ (void)setServerEnvironment:(VTServerEnvironment)environment {
    
    if (environment == VTServerEnvironmentProduction) {
        [[MidtransPrivateConfig sharedInstance] setBaseUrl: VT_PRODUCTION_API_URL];
        [[MidtransPrivateConfig sharedInstance] setMixpanelToken: VT_PRODUCTION_MIXPANEL];
        [[MidtransPrivateConfig sharedInstance] setSnapURL: VT_PROD_SNAP];
    } else {
        [[MidtransPrivateConfig sharedInstance] setBaseUrl: VT_SANDBOX_API_URL];
        [[MidtransPrivateConfig sharedInstance] setMixpanelToken:VT_SANDBOX_MIXPANEL];
        [[MidtransPrivateConfig sharedInstance] setSnapURL: VT_SANDBOX_SNAP];
    }
    
}
@end
