//
//  VTConfig.h
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 2/16/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "VTMerchantAuth.h"

typedef NS_ENUM(NSUInteger, VTCreditCardFeature) {
    VTCreditCardFeatureOneClick,
    VTCreditCardFeatureTwoClick,
    VTCreditCardFeatureNormal,
    VTCreditCardFeatureUnknown
};

typedef NS_ENUM(NSUInteger, VTServerEnvironment) {
    VTServerEnvironmentSandbox,
    VTServerEnvironmentProduction,
    VTServerEnvironmentUnknown
};

#define CONFIG (VTConfig *)[VTConfig sharedInstance]

@interface VTConfig : NSObject

+ (id)sharedInstance;

@property (nonatomic) VTMerchantAuth *merchantAuth;
@property (nonatomic) VTCreditCardFeature creditCardFeature;
@property (nonatomic) NSString *clientKey;
@property (nonatomic) NSString *merchantServerURL;
@property (nonatomic) VTServerEnvironment environment;

@property (nonatomic, readonly) NSString *baseUrl;

@end