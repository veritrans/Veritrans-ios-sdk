//
//  VTCreditCardConfig.m
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 8/10/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTCreditCardConfig.h"

@interface VTCreditCardConfig()
@property (nonatomic, readwrite) VTCreditCardPaymentType paymentType;
@property (nonatomic, readwrite) BOOL secure;
@property (nonatomic, readwrite) BOOL saveCard;
@end

@implementation VTCreditCardConfig

+ (id)sharedInstance {
    static VTCreditCardConfig *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

+ (void)setPaymentType:(VTCreditCardPaymentType)paymentType secure:(BOOL)secure {
    [[VTCreditCardConfig sharedInstance] setSecure:secure];
    [[VTCreditCardConfig sharedInstance] setPaymentType:paymentType];
    
    switch (paymentType) {
        case VTCreditCardPaymentTypeNormal:
            [[VTCreditCardConfig sharedInstance] setSaveCard:NO];
            break;
        default: {
            [[VTCreditCardConfig sharedInstance] setSaveCard:YES];
            break;
        }
            
    }
}

+ (void)enableSaveCard:(BOOL)enabled {
    [[VTCreditCardConfig sharedInstance] setSaveCard:enabled];
}

@end

