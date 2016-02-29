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
@property (nonatomic, strong) NSString *environment;
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

+ (instancetype)configWithClientKey:(NSString *)clientKey merchantServerURL:(NSString *)merchantServerURL environment:(NSString *)environment {
    VTConfig *config = [VTConfig sharedInstance];
    config.clientKey = clientKey;
    config.merchantServerURL = merchantServerURL;
    config.environment = environment;
    return config;
}

- (void)setEnvironment:(NSString *)environment {
    _environment = environment;
    
    [self setBaseUrlWithEnvironment:environment];
    
}

- (void)setBaseUrlWithEnvironment:(NSString *)environment {
    if ([environment isEqualToString:VTEnvironmentProduction]) {
        self.baseUrl = @"https://api.veritrans.co.id/v2";
    } else if ([environment isEqualToString:VTEnvironmentSandbox]) {
        self.baseUrl = @"https://api.sandbox.veritrans.co.id/v2";
    } else {
        NSAssert(NO, @"Wrong environment type!");
    }
}

@end