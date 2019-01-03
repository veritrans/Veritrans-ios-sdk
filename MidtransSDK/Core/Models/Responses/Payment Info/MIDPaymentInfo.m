//
//  MIDPaymentInfo.m
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 10/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import "MIDPaymentInfo.h"
#import "MIDModelHelper.h"

@implementation MIDPaymentInfo

- (NSDictionary *)dictionaryValue {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    [result setValue:[self.callbacks dictionaryValue] forKey:@"callbacks"];
    [result setValue:[self.creditCard dictionaryValue] forKey:@"credit_card"];
    [result setValue:[self.merchant dictionaryValue] forKey:@"merchant"];
    [result setValue:[self.promo dictionaryValue] forKey:@"promo_details"];
    [result setValue:self.token forKey:@"token"];
    [result setValue:[self.transaction dictionaryValue] forKey:@"transaction_details"];
    [result setValue:[self.enabledPayments dictionaryValues] forKey:@"enabled_payments"];
    return result;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        self.token = [dictionary objectOrNilForKey:@"token"];
        self.callbacks = [[MIDCallbackInfo alloc] initWithDictionary:[dictionary objectOrNilForKey:@"callbacks"]];
        self.creditCard = [[MIDCreditCardInfo alloc] initWithDictionary:[dictionary objectOrNilForKey:@"credit_card"]];
        self.merchant = [[MIDMerchantInfo alloc] initWithDictionary:[dictionary objectOrNilForKey:@"merchant"]];
        self.promo = [[MIDPromoInfo alloc] initWithDictionary:[dictionary objectOrNilForKey:@"promo_details"]];
        self.transaction = [[MIDTransactionInfo alloc] initWithDictionary:[dictionary objectOrNilForKey:@"transaction_details"]];
        self.enabledPayments = [[dictionary objectOrNilForKey:@"enabled_payments"] mapToArray:[MIDPaymentMethodInfo class]];
    }
    return self;
}

@end
