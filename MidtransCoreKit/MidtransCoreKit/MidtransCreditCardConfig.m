//
//  MidtransCreditCardConfig.m
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 8/10/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MidtransCreditCardConfig.h"

@interface MidtransCreditCardConfig()
@property (nonatomic) BOOL secureSnapEnabled;
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

- (void)setPaymentType:(MTCreditCardPaymentType)paymentType {
    _paymentType = paymentType;
    
    switch (paymentType) {
        case MTCreditCardPaymentTypeOneclick:
            self.secureSnapEnabled = YES;
            break;
        default:
            self.secureSnapEnabled = NO;
            break;
    }
}

@end

