//
//  MIDTelkomselCashPayment.m
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 21/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import "MIDTelkomselCashPayment.h"

@implementation MIDTelkomselCashPayment

- (instancetype)initWithPhoneNumber:(NSString *)phoneNumber {
    if (self = [super init]) {
        self.phoneNumber = phoneNumber;
    }
    return self;
}

- (NSDictionary *)dictionaryValue {
    return @{@"payment_type":@"telkomsel_cash",
             @"payment_params":@{@"customer":self.phoneNumber}
             };
}

@end
