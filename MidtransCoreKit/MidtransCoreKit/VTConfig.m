//
//  VTConfig.m
//  iossdk-gojek
//
//  Created by Nanang Rafsanjani on 2/16/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTConfig.h"
#import "VTConstant.h"
#import "VTMerchantClient.h"
#import "VTPrivateConfig.h"

@interface VTConfig ()
@property (nonatomic) NSString *clientKey;
@property (nonatomic) NSString *merchantServerURL;
@property (nonatomic) VTServerEnvironment environment;
@end

@implementation VTConfig

+ (void)setClientKey:(NSString *)clientKey merchantServerURL:(NSString *)merchantServerURL serverEnvironment:(VTServerEnvironment)environment {
    [[VTConfig sharedInstance] setClientKey:clientKey];
    [[VTConfig sharedInstance] setMerchantServerURL:merchantServerURL];
    [[VTConfig sharedInstance] setEnvironment:environment];
}

+ (void)setClientKey:(NSString *)clientKey merchantServerURL:(NSString *)merchantServerURL serverEnvironment:(VTServerEnvironment)environment merchantClientData:(id)merchantClientData {
    [VTConfig setClientKey:clientKey merchantServerURL:merchantServerURL serverEnvironment:environment];
    [[VTConfig sharedInstance] setMerchantClientData:merchantClientData];
}

- (NSString *)merchantServerURL {
    NSAssert(_merchantServerURL, VT_MESSAGE_MERCHANT_SERVER_NOT_SET);
    return _merchantServerURL;
}

- (NSString *)clientKey {
    NSAssert(_clientKey, VT_MESSAGE_CLIENT_KEY_NOT_SET);
    return _clientKey;
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
    [VTPrivateConfig setServerEnvironment:environment];    
}

@end