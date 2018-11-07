//
//  MTClient.h
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 07/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 The payment server types.
 */
typedef NS_ENUM(NSUInteger, MTEnvironment) {
    /**
     Sandbox payment environment. This server type should be used for testing.
     */
    MTEnvironmentSandbox,
    
    
    MTEnvironmentStaging,
    /**
     Production payment environment. This server type should be used only when the product ready to be released.
     */
    MTEnvironmentProduction,
    
    /**
     Unknown payment environment. Internal usage only.
     */
    MTEnvironmentUnknown
};


@interface MTClient : NSObject
    
@property (readonly, nonnull) NSString *clientKey;
@property (readonly, nonnull) NSString *merchantServerURL;
@property (readonly) MTEnvironment environment;

- (void)configureClientKey:(NSString *)clientKey
         merchantServerURL:(NSString *)merchantServerURL
               environment:(MTEnvironment)environment;
+ (MTClient *)shared;

@end

NS_ASSUME_NONNULL_END
