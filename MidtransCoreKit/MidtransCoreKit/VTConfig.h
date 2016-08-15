//
//  VTConfig.h
//  iossdk-gojek
//
//  Created by Nanang Rafsanjani on 2/16/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "VTEnvironment.h"

#define CONFIG (VTConfig *)[VTConfig sharedInstance]

/**
 Object that holds configuration information.
 */
@interface VTConfig : NSObject

+ (id)sharedInstance;

///------------------------------
/// @name Veritrans Configuration
///------------------------------

/**
 The Veritrans' client key for this app.
 */
@property (nonatomic, readonly) NSString *clientKey;

/**
 The merchant server URL. This URL will be used by `VTMerchantClient`.
 */
@property (nonatomic, readonly) NSString *merchantServerURL;

/**
 The payment environment this app will use.
 */
@property (nonatomic, readonly) VTServerEnvironment environment;

/**
 Container for data that will be sent to the Merchant Server. The common use-case for this data is to identify client to the Merchant Server. If this variable is set to non-nil, then every request to the Merchant Server will contain this data in its HTTP request header.
 
 Note that each key and value pair must be an NSString* instances.
 */
@property (nonatomic) NSDictionary *merchantClientData;
@property (nonatomic) NSDictionary *merchantDefaultHeader;

+ (void)setClientKey:(NSString *)clientKey merchantServerURL:(NSString *)merchantServerURL serverEnvironment:(VTServerEnvironment)environment;

+ (void)setClientKey:(NSString *)clientKey merchantServerURL:(NSString *)merchantServerURL serverEnvironment:(VTServerEnvironment)environment merchantClientData:(id)merchantClientData;

@end