//
//  VTPrivateConfig.m
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 5/31/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTPrivateConfig.h"
#import "VTConstant.h"
@interface VTPrivateConfig()
@property (nonatomic) NSString *baseUrl;
@property (nonatomic) NSString *mixpanelToken;
@property (nonatomic) NSString *snapURL;
@end

@implementation VTPrivateConfig

+ (id)sharedInstance {
    static VTPrivateConfig *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

+ (void)setServerEnvironment:(VTServerEnvironment)environment {
    
    if (environment == VTServerEnvironmentProduction) {
        [[VTPrivateConfig sharedInstance] setBaseUrl: VT_PRODUCTION_API_URL];
        [[VTPrivateConfig sharedInstance] setMixpanelToken: VT_PRODUCTION_MIXPANEL];
        [[VTPrivateConfig sharedInstance] setSnapURL: VT_PROD_SNAP];
    } else {
        [[VTPrivateConfig sharedInstance] setBaseUrl: VT_SANDBOX_API_URL];
        [[VTPrivateConfig sharedInstance] setMixpanelToken:VT_SANDBOX_MIXPANEL];
        [[VTPrivateConfig sharedInstance] setSnapURL: VT_SANDBOX_SNAP];
    }
    
}
@end
