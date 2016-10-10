//
//  MidtransConfig.h
//  iossdk-gojek
//
//  Created by Nanang Rafsanjani on 2/16/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MidtransEnvironment.h"

#define CONFIG (MidtransConfig *)[MidtransConfig sharedInstance]

/**
 Object that holds configuration information.
 */
@interface MidtransConfig : NSObject

+ (id)sharedInstance;
/**
 *  The Veritrans' client key for this app.
 */
@property (nonatomic, readonly) NSString *clientKey;
/**
 * The Veritrans' evnirontment key for this app.
 */
@property (nonatomic, readonly) MIdtransServerEnvironment environment;

@property (nonatomic, readonly) NSString *merchantURL;

@property (nonatomic) double timeoutInterval;

/**
 Container for data that will be sent to the Merchant Server. The common use-case for this data is to identify client to the Merchant Server. If this variable is set to non-nil, then every request to the Merchant Server will contain this data in its HTTP request header.
 
 Note that each key and value pair must be an NSString* instances.
 */
@property (nonatomic) NSDictionary *merchantClientData;
@property (nonatomic) NSDictionary *merchantDefaultHeader;

+ (void)setClientKey:(NSString *)clientKey serverEnvironment:(MIdtransServerEnvironment)environment merchantURL:(NSString *)merchantURL;

@end