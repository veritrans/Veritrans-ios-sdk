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
@property (nonatomic) NSString *binURL;
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
        [[MidtransPrivateConfig shared] setSnapURL: MIDTRANS_PRODUCTION_SNAP];
        [[MidtransPrivateConfig shared] setBinURL:MIDTRANS_PRODUCTION_BIN_URL];
    }
    else if (env == MidtransServerEnvironmentStaging) {
        [[MidtransPrivateConfig shared] setBaseUrl: MIDTRANS_STAGING_API_URL];
        [[MidtransPrivateConfig shared] setMixpanelToken: MIDTRANS_STAGING_MIXPANEL];
        [[MidtransPrivateConfig shared] setSnapURL: MIDTRANS_STAGING_SNAP];
        [[MidtransPrivateConfig shared] setBinURL:MIDTRANS_STAGING_BIN_URL];
    }
    else {
        [[MidtransPrivateConfig shared] setBaseUrl: MIDTRANS_SANDBOX_API_URL];
        [[MidtransPrivateConfig shared] setMixpanelToken:MIDTRANS_SANDBOX_MIXPANEL];
        [[MidtransPrivateConfig shared] setSnapURL: MIDTRANS_SANDBOX_SNAP];
        [[MidtransPrivateConfig shared] setBinURL:MIDTRANS_SANDBOX_BIN_URL];
    }
}
@end
