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

#define CONFIG ((MidtransConfig *)[MidtransConfig shared])

/**
 Object that holds configuration information.
 */
@interface MidtransConfig : NSObject

+ (MidtransConfig *)shared;
/**
 *  The Veritrans' client key for this app.
 */
@property (nonatomic, readonly) NSString *clientKey;
/**
 * The Veritrans' evnirontment key for this app.
 */
@property (nonatomic, readonly) MidtransServerEnvironment environment;

@property (nonatomic, readonly) NSString *merchantURL;

@property (nonatomic) double timeoutInterval;

@property (nonatomic) NSString *customPermataVANumber;

@property (nonatomic) NSString *customBCAVANumber;
@property (nonatomic) NSString *customBCASubcompanyCode;
@property (nonatomic) NSString *customPermataVARecipientName;
@property (nonatomic) NSString *customBNIVANumber;

@property (nonatomic) NSArray *customPaymentChannels;
@property (nonatomic) NSDictionary *customFreeText;

/**
 Container for data that will be sent to the Merchant Server. The common use-case for this data is to identify client to the Merchant Server. If this variable is set to non-nil, then every request to the Merchant Server will contain this data in its HTTP request header.
 
 Note that each key and value pair must be an NSString* instances.
 */
@property (nonatomic) NSDictionary *merchantClientData;
@property (nonatomic) NSDictionary *merchantDefaultHeader;

- (void)setClientKey:(NSString *)clientKey environment:(MidtransServerEnvironment)env merchantServerURL:(NSString *)merchantServerURL;

@end
