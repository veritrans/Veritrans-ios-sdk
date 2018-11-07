//
//  MTClient.m
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 07/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import "MTClient.h"

@interface MTClient()
@property (readwrite, nonnull) NSString *clientKey;
@property (readwrite, nonnull) NSString *merchantServerURL;
@property (readwrite) MTEnvironment environment;
@end

@implementation MTClient

+ (MTClient *)shared {
    static MTClient *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}
    
- (void)configureClientKey:(NSString *)clientKey
               environment:(MTEnvironment)environment
         merchantServerURL:(NSString *)merchantServerURL {
    self.clientKey = clientKey;
    self.merchantServerURL = merchantServerURL;
    if (environment) {
        self.environment = environment;
    } else {
        self.environment = MTEnvironmentSandbox;
    }
}
    
@end
