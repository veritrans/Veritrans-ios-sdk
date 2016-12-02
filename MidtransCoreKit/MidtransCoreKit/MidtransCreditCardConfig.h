//
//  MidtransCreditCardConfig.h
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 8/10/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CC_CONFIG ((MidtransCreditCardConfig *)[MidtransCreditCardConfig shared])

typedef NS_ENUM(NSUInteger, MTCreditCardPaymentType) {
    MTCreditCardPaymentTypeNormal,
    MTCreditCardPaymentTypeOneclick,
    MTCreditCardPaymentTypeTwoclick
};

@interface MidtransCreditCardConfig : NSObject

@property (nonatomic) MTCreditCardPaymentType paymentType;
@property (nonatomic, readonly) BOOL secureSnapEnabled;
@property (nonatomic) BOOL secure3DEnabled;
@property (nonatomic) BOOL saveCardEnabled;
@property (nonatomic) BOOL tokenStorageEnabled;
@property (nonatomic) NSString *bank;
@property (nonatomic) NSString *channel;

+ (MidtransCreditCardConfig *)shared;

@end
