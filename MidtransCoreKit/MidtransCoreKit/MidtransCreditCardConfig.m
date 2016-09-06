//
//  VTCreditCardConfig.m
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 8/10/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MidtransCreditCardConfig.h"

@interface MidtransCreditCardConfig()
@property (nonatomic, readwrite) VTCreditCardPaymentType paymentType;
@property (nonatomic, readwrite) BOOL secure;
@property (nonatomic, readwrite) BOOL saveCard;
@end

@implementation MidtransCreditCardConfig

+ (id)sharedInstance {
    static MidtransCreditCardConfig *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

+ (void)setPaymentType:(VTCreditCardPaymentType)paymentType secure:(BOOL)secure {
    [[MidtransCreditCardConfig sharedInstance] setSecure:secure];
    [[MidtransCreditCardConfig sharedInstance] setPaymentType:paymentType];
    
    switch (paymentType) {
        case VTCreditCardPaymentTypeNormal:
            [[MidtransCreditCardConfig sharedInstance] setSaveCard:NO];
            break;
        default: {
            [[MidtransCreditCardConfig sharedInstance] setSaveCard:YES];
            break;
        }
            
    }
}

+ (void)enableSaveCard:(BOOL)enabled {
    [[MidtransCreditCardConfig sharedInstance] setSaveCard:enabled];
}

@end

