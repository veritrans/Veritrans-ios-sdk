//
//  MidtransConfig.m
//  iossdk-gojek
//
//  Created by Nanang Rafsanjani on 2/16/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MidtransConfig.h"
#import "MidtransConstant.h"
#import "MidtransMerchantClient.h"
#import "MidtransPrivateConfig.h"

@interface MidtransConfig ()
@property (nonatomic) NSString *clientKey;
@property (nonatomic) NSString *merchantURL;
@property (nonatomic) MidtransServerEnvironment environment;
@end

@implementation MidtransConfig

+ (MidtransConfig *)shared {
    static MidtransConfig *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

- (void)setClientKey:(NSString *)clientKey
         environment:(MidtransServerEnvironment)env
   merchantServerURL:(NSString *)merchantServerURL {
    self.clientKey = clientKey;
    self.environment = env;
    self.merchantURL = merchantServerURL;
}

- (void)setMerchantURL:(NSString *)merchantURL {
    //sanitize url
    if ([merchantURL hasSuffix:@"/"]) {
        merchantURL = [merchantURL substringToIndex:merchantURL.length - 1];
    }
    _merchantURL = merchantURL;
}

- (double)timeoutInterval {
    if (_timeoutInterval == 0) {
        //default timeout
        _timeoutInterval = 1000;
    }
    return _timeoutInterval;
}

- (void)setEnvironment:(MidtransServerEnvironment)environment {
    _environment = environment;
    PRIVATECONFIG.env = environment;
}

@end
