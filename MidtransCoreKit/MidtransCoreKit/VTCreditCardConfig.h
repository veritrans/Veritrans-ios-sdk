//
//  VTCreditCardConfig.h
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 8/10/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CC_CONFIG (VTCreditCardConfig *)[VTCreditCardConfig sharedInstance]

typedef NS_ENUM(NSUInteger, VTCreditCardPaymentType) {
    VTCreditCardPaymentTypeOneclick,
    VTCreditCardPaymentTypeTwoclick,
    VTCreditCardPaymentTypeNormal
};

@interface VTCreditCardConfig : NSObject

@property (nonatomic, readonly) VTCreditCardPaymentType paymentType;
@property (nonatomic, readonly) BOOL secure;
@property (nonatomic, readonly) BOOL saveCard;

+ (void)setPaymentType:(VTCreditCardPaymentType)paymentType secure:(BOOL)secure;
+ (void)enableSaveCard:(BOOL)enabled;
+ (instancetype)sharedInstance;

@end