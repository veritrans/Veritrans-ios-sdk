//
//  MIDTransactionInfo.m
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 10/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import "MIDTransactionInfo.h"
#import "MIDModelHelper.h"

@implementation MIDTransactionInfo

- (NSDictionary *)dictionaryValue {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    [result setValue:[NSString nameOfCurrency:self.currency] forKey:@"currency"];
    [result setValue:self.grossAmount forKey:@"gross_amount"];
    [result setValue:self.orderID forKey:@"order_id"];
    return result;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        self.currency = [[dictionary objectOrNilForKey:@"currency"] currencyType];
        self.grossAmount = [dictionary objectOrNilForKey:@"gross_amount"];
        self.orderID = [dictionary objectOrNilForKey:@"order_id"];
    }
    return self;
}

@end
