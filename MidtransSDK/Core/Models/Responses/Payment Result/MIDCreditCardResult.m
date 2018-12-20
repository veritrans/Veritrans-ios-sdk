//
//  MIDCreditCardResult.m
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 14/12/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import "MIDCreditCardResult.h"

@implementation MIDCreditCardResult

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super initWithDictionary:dictionary]) {
        self.approvalCode = [dictionary objectOrNilForKey:@"approval_code"];
        self.bank = [dictionary objectOrNilForKey:@"bank"];
        self.cardType = [dictionary objectOrNilForKey:@"card_type"];
        self.fraudStatus = [dictionary objectOrNilForKey:@"fraud_status"];
        self.maskedCard = [dictionary objectOrNilForKey:@"masked_card"];
    }
    return self;
}

- (NSDictionary *)dictionaryValue {
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary:[super dictionaryValue]];
    [result setValue:self.approvalCode forKey:@"approval_code"];
    [result setValue:self.bank forKey:@"bank"];
    [result setValue:self.cardType forKey:@"card_type"];
    [result setValue:self.fraudStatus forKey:@"fraud_status"];
    [result setValue:self.maskedCard forKey:@"masked_card"];
    return result;
}

@end
