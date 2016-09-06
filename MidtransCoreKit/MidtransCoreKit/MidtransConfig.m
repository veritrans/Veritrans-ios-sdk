//
//  VTConfig.m
//  iossdk-gojek
//
//  Created by Nanang Rafsanjani on 2/16/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MidtransConfig.h"
#import "VTConstant.h"
#import "MidtransMerchantClient.h"
#import "MidtransPrivateConfig.h"

@interface MidtransConfig ()
@property (nonatomic) NSString *clientKey;
@property (nonatomic) NSString *merchantURL;
@property (nonatomic) VTServerEnvironment environment;
@end

@implementation MidtransConfig

+ (void)setClientKey:(NSString *)clientKey serverEnvironment:(VTServerEnvironment)environment merchantURL:(NSString *)merchantURL {
    [[MidtransConfig sharedInstance] setClientKey:clientKey];
    [[MidtransConfig sharedInstance] setEnvironment:environment];
    [[MidtransConfig sharedInstance] setMerchantURL:merchantURL];
}

- (NSString *)clientKey {
    NSAssert(_clientKey, VT_MESSAGE_CLIENT_KEY_NOT_SET);
    return _clientKey;
}

+ (id)sharedInstance {
    static MidtransConfig *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

- (void)setEnvironment:(VTServerEnvironment)environment {
    [MidtransPrivateConfig setServerEnvironment:environment];
}

- (double)timeoutInterval {
    if (_timeoutInterval == 0) {
        //default timeout
        _timeoutInterval = 20;
    }
    return _timeoutInterval;
}

@end