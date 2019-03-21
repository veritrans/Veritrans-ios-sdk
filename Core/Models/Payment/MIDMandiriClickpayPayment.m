//
//  MIDMandiriClickpayPayment.m
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 21/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import "MIDMandiriClickpayPayment.h"

@implementation MIDMandiriClickpayPayment

- (instancetype)initWithCardToken:(NSString *)cardToken clickpayToken:(NSString *)clickpayToken input3:(NSString *)input3 {
    if (self = [super init]) {
        self.cardToken = cardToken;
        self.clickpayToken = clickpayToken;
        self.input3 = input3;
    }
    return self;
}

- (NSDictionary *)dictionaryValue {
    NSDictionary *params = @{@"token_id":self.cardToken,
                             @"input3":self.input3,
                             @"token":self.clickpayToken
                             };
    return @{@"payment_type":@"mandiri_clickpay",
             @"payment_params":params
             };
}

@end
