//
//  MIDTransaction.m
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 10/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import "MIDCheckoutTransaction.h"
#import "MIDModelHelper.h"

@implementation MIDCheckoutTransaction

- (NSDictionary *)dictionaryValue {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    [result setValue:self.orderID forKey:@"order_id"];
    [result setValue:self.grossAmount forKey:@"gross_amount"];
    [result setValue:[NSString nameOfCurrency:self.currency] forKey:@"currency"];
    return @{@"transaction_details": result};
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        self.orderID = [dictionary objectOrNilForKey:@"order_id"];
        self.grossAmount = [dictionary objectOrNilForKey:@"gross_amount"];
        self.currency = [[dictionary objectOrNilForKey:@"currency"] currencyType];
    }
    return self;
}

+ (instancetype)modelWithOrderID:(NSString *)orderID
                     grossAmount:(NSNumber *)grossAmount
                        currency:(MIDCurrency)currency {
    MIDCheckoutTransaction *obj = [MIDCheckoutTransaction new];
    obj.orderID = orderID;
    obj.grossAmount = grossAmount;
    obj.currency = currency;
    return obj;
}

@end
