//
//  MIDTelkomselCashPayment.m
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 20/02/19.
//  Copyright © 2019 Midtrans. All rights reserved.
//

#import "MIDTelkomselCashPayment.h"

@implementation MIDTelkomselCashPayment

- (instancetype)initWithCustomer:(NSString *)customer {
    if (self = [super init]) {
        self.customer = customer;
    }
    return self;
}

- (NSDictionary *)dictionaryValue {
    NSMutableDictionary *result = [NSMutableDictionary new];
    [result setValue:@"telkomsel_cash" forKey:@"payment_type"];
    if (self.customer) {
        [result setValue:@{@"customer":self.customer} forKey:@"payment_params"];
    }
    return result;
}

@end
