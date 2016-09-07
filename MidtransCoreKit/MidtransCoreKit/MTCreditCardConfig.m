//
//  MTCreditCardConfig.m
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 8/10/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MTCreditCardConfig.h"

@interface MTCreditCardConfig()
@property (nonatomic, readwrite) MTCreditCardPaymentType paymentType;
@property (nonatomic, readwrite) BOOL secure;
@property (nonatomic, readwrite) BOOL saveCard;
@end

@implementation MTCreditCardConfig

+ (id)sharedInstance {
    static MTCreditCardConfig *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

+ (void)setPaymentType:(MTCreditCardPaymentType)paymentType secure:(BOOL)secure {
    [[MTCreditCardConfig sharedInstance] setSecure:secure];
    [[MTCreditCardConfig sharedInstance] setPaymentType:paymentType];
    
    switch (paymentType) {
        case VTCreditCardPaymentTypeNormal:
            [[MTCreditCardConfig sharedInstance] setSaveCard:NO];
            break;
        default: {
            [[MTCreditCardConfig sharedInstance] setSaveCard:YES];
            break;
        }
            
    }
}

+ (void)enableSaveCard:(BOOL)enabled {
    [[MTCreditCardConfig sharedInstance] setSaveCard:enabled];
}

@end

