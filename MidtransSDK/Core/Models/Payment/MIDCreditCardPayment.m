//
//  MIDCreditCardPayment.m
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 14/12/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import "MIDCreditCardPayment.h"
#import "MIDModelHelper.h"

@implementation MIDCreditCardPayment

- (NSDictionary *)dictionaryValue {
    NSMutableDictionary *result = [NSMutableDictionary new];
    [result setValue:@"credit_card" forKey:@"payment_type"];
    
    if ([self paymentParams].count > 0) {
        [result setValue:[self paymentParams] forKey:@"payment_params"];
    }
    
    if ([self customerDetail].count > 0) {
        [result setValue:[self customerDetail] forKey:@"customer_details"];
    }
    
    return result;
}

- (NSDictionary *)customerDetail {
    NSMutableDictionary *result = [NSMutableDictionary new];
    [result setValue:self.fullName forKey:@"full_name"];
    [result setValue:self.email forKey:@"email"];
    [result setValue:self.phoneNumber forKey:@"phone"];
    return result;
}

- (NSDictionary *)paymentParams {
    NSMutableDictionary *result = [NSMutableDictionary new];
    [result setValue:self.creditCardToken forKey:@"card_token"];
    [result setValue:self.installment forKey:@"installment"];
    [result setValue:self.point forKey:@"point"];
    [result setValue:[NSString stringFromBool:self.saveCard] forKey:@"save_card"];
    return result;
}

@end
