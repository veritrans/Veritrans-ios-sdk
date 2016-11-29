//
//  MidtransPrivateConfig.m
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 5/31/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MidtransPrivateConfig.h"
#import "MidtransConstant.h"
@interface MidtransPrivateConfig()
@property (nonatomic) NSString *baseUrl;
@property (nonatomic) NSString *mixpanelToken;
@property (nonatomic) NSString *snapURL;
@end

@implementation MidtransPrivateConfig

+ (MidtransPrivateConfig *)shared {
    static MidtransPrivateConfig *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

- (void)setEnv:(MidtransServerEnvironment)env {
    _env = env;
    if (env == MidtransServerEnvironmentProduction) {
        [[MidtransPrivateConfig shared] setBaseUrl: MIDTRANS_PRODUCTION_API_URL];
        [[MidtransPrivateConfig shared] setMixpanelToken: MIDTRANS_PRODUCTION_MIXPANEL];
        [[MidtransPrivateConfig shared] setSnapURL: MIDTRANS_PROD_SNAP];
    }
    else if (env == MidtransServerEnvironmentStaging) {
        [[MidtransPrivateConfig shared] setBaseUrl: MIDTRANS_SANDBOX_API_URL];
        [[MidtransPrivateConfig shared] setMixpanelToken: MIDTRANS_SANDBOX_MIXPANEL];
        [[MidtransPrivateConfig shared] setSnapURL: MIDTRANS_SANDBOX_SNAP];
    }
    else {
        [[MidtransPrivateConfig shared] setBaseUrl: MIDTRANS_SANDBOX_API_URL];
        [[MidtransPrivateConfig shared] setMixpanelToken:MIDTRANS_SANDBOX_MIXPANEL];
        [[MidtransPrivateConfig shared] setSnapURL: MIDTRANS_SANDBOX_SNAP];
    }
}
@end
