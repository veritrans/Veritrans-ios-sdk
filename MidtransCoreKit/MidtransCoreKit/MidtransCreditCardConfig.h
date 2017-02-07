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

typedef NS_ENUM(NSUInteger, MTAcquiringBank) {
    MTAcquiringBankUnknown,
    MTAcquiringBankBCA,
    MTAcquiringBankBRI,
    MTAcquiringBankCIMB,
    MTAcquiringBankMandiri,
    MTAcquiringBankBNI,
    MTAcquiringBankMaybank
};

@interface MidtransCreditCardConfig : NSObject

@property (nonatomic) MTCreditCardPaymentType paymentType;
@property (nonatomic, readonly) BOOL secureSnapEnabled;
@property (nonatomic) BOOL secure3DEnabled;
@property (nonatomic) BOOL setDefaultCreditSaveCardEnabled;
@property (nonatomic) BOOL saveCardEnabled;
@property (nonatomic) BOOL tokenStorageEnabled;
@property (nonatomic) MTAcquiringBank acquiringBank;
@property (nonatomic, readonly) NSString *acquiringBankString;
@property (nonatomic, readonly) NSString *channel;

/*
 Boolean value to set pre-auth credit card transaction
 */
@property (nonatomic, assign) BOOL preauthEnabled;

+ (MidtransCreditCardConfig *)shared;

@end
