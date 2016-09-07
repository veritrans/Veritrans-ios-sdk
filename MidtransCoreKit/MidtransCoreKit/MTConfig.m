//
//  MTConfig.m
//  iossdk-gojek
//
//  Created by Nanang Rafsanjani on 2/16/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MTConfig.h"
#import "MTConstant.h"
#import "VTMerchantClient.h"
#import "MTPrivateConfig.h"

@interface MTConfig ()
@property (nonatomic) NSString *clientKey;
@property (nonatomic) NSString *merchantURL;
@property (nonatomic) MTServerEnvironment environment;
@end

@implementation MTConfig

+ (void)setClientKey:(NSString *)clientKey serverEnvironment:(MTServerEnvironment)environment merchantURL:(NSString *)merchantURL {
    [[MTConfig sharedInstance] setClientKey:clientKey];
    [[MTConfig sharedInstance] setEnvironment:environment];
    [[MTConfig sharedInstance] setMerchantURL:merchantURL];
}

- (NSString *)clientKey {
    NSAssert(_clientKey, MT_MESSAGE_CLIENT_KEY_NOT_SET);
    return _clientKey;
}

+ (id)sharedInstance {
    static MTConfig *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

- (void)setEnvironment:(MTServerEnvironment)environment {
    [MTPrivateConfig setServerEnvironment:environment];
}

- (double)timeoutInterval {
    if (_timeoutInterval == 0) {
        //default timeout
        _timeoutInterval = 20;
    }
    return _timeoutInterval;
}

@end