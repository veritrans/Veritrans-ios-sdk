//
//  MidtransCreditCardConfig.m
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 8/10/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MidtransCreditCardConfig.h"

@interface MidtransCreditCardConfig()
@property (nonatomic, readwrite) MTCreditCardPaymentType paymentType;
@property (nonatomic, readwrite) BOOL secure;
@property (nonatomic, readwrite) BOOL saveCard;
@end

@implementation MidtransCreditCardConfig

+ (MidtransCreditCardConfig *)shared {
    static MidtransCreditCardConfig *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

+ (void)setPaymentType:(MTCreditCardPaymentType)paymentType secure:(BOOL)secure {
    [[MidtransCreditCardConfig shared] setSecure:secure];
    [[MidtransCreditCardConfig shared] setPaymentType:paymentType];
    
    switch (paymentType) {
            case VTCreditCardPaymentTypeNormal: {
                [[MidtransCreditCardConfig shared] setSaveCard:NO];
                break;
            }
        default: {
            [[MidtransCreditCardConfig shared] setSaveCard:YES];
            break;
        }
            
    }
}

+ (void)enableSaveCard:(BOOL)enabled {
    [[MidtransCreditCardConfig shared] setSaveCard:enabled];
}

+ (void)disableTokenStorage:(BOOL)disabled {
    [[MidtransCreditCardConfig shared] setTokenStorageDisabled:disabled];
}
@end

