//
//  MidtransCreditCardConfig.h
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 8/10/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CC_CONFIG (MidtransCreditCardConfig *)[MidtransCreditCardConfig sharedInstance]

typedef NS_ENUM(NSUInteger, MTCreditCardPaymentType) {
    VTCreditCardPaymentTypeOneclick,
    VTCreditCardPaymentTypeTwoclick,
    VTCreditCardPaymentTypeNormal
};

@interface MidtransCreditCardConfig : NSObject

@property (nonatomic, readonly) MTCreditCardPaymentType paymentType;
@property (nonatomic, readonly) BOOL secure;
@property (nonatomic, readonly) BOOL saveCard;

+ (void)setPaymentType:(MTCreditCardPaymentType)paymentType secure:(BOOL)secure;
+ (void)enableSaveCard:(BOOL)enabled;
+ (instancetype)sharedInstance;

@end