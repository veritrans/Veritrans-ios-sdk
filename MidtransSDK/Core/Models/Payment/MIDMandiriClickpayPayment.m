//
//  MIDMandiriClickpayPayment.m
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 21/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import "MIDMandiriClickpayPayment.h"

@implementation MIDMandiriClickpayPayment

- (instancetype)initWithCardToken:(NSString *)cardToken clickpayToken:(NSString *)clickpayToken {
    if (self = [super init]) {
        self.cardToken = cardToken;
        self.clickpayToken = clickpayToken;
    }
    return self;
}

- (NSDictionary *)dictionaryValue {
    NSDictionary *params = @{@"token_id":self.cardToken,
                             @"input3":[self generateInput3],
                             @"token":self.clickpayToken
                             };
    return @{@"payment_type":@"mandiri_clickpay",
             @"payment_params":params
             };
}

- (NSString *)generateInput3 {
    NSString *letters = @"0123456789";
    NSInteger len = 5;
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    for (int i=0; i < len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform((int)[letters length])]];
    }
    return randomString;
}

@end
