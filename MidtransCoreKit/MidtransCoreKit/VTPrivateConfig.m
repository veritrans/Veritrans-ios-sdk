//
//  VTPrivateConfig.m
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 5/31/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTPrivateConfig.h"

@interface VTPrivateConfig()
@property (nonatomic) NSString *baseUrl;
@property (nonatomic) NSString *mixpanelToken;
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
        [[VTPrivateConfig sharedInstance] setBaseUrl: @"https://api.veritrans.co.id/v2"];
        [[VTPrivateConfig sharedInstance] setMixpanelToken:@"cc005b296ca4ce612fe3939177c668bb"];
    } else {
        [[VTPrivateConfig sharedInstance] setBaseUrl: @"https://api.sandbox.veritrans.co.id/v2"];
        [[VTPrivateConfig sharedInstance] setMixpanelToken:@"0269722c477a0e085fde32e0248c6003"];
    }
}
@end
