//
//  MIDCreditCardPayment.m
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 14/12/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import "MIDCreditCardPayment.h"

@implementation MIDCreditCardPayment

- (NSDictionary *)dictionaryValue {
    NSMutableDictionary *result = [NSMutableDictionary new];
    [result setValue:@"credit_card" forKey:@"payment_type"];
    [result setValue:[self paymentParams] forKey:@"payment_params"];
    return result;
}

- (NSDictionary *)paymentParams {
    NSMutableDictionary *result = [NSMutableDictionary new];
    [result setValue:self.maskedCardNumber forKey:@"masked_card"];
    [result setValue:self.creditCardToken forKey:@"card_token"];
    [result setValue:@(self.saveCard) forKey:@"save_card"];
    return result;
}

@end
