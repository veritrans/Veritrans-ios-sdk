//
//  VTConfig.h
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 2/16/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <Foundation/Foundation.h>

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

+ (void)setCreditCardPaymentFeature:(VTCreditCardFeature)creditCardFeature;
+ (void)setCreditCardSecurePayment:(BOOL)secure;
+ (void)setMerchantServerURL:(NSString *)merchantServerURL;
+ (void)setServerEnvironment:(VTServerEnvironment)environment;
+ (void)setClientKey:(NSString *)clientKey;

@property (nonatomic, readonly) VTCreditCardFeature creditCardFeature;
@property (nonatomic, readonly) NSString *baseUrl;
@property (nonatomic, readonly) NSString *clientKey;
@property (nonatomic, readonly) NSString *merchantServerURL;
@property (nonatomic, readonly) BOOL secureCreditCardPayment;

@end