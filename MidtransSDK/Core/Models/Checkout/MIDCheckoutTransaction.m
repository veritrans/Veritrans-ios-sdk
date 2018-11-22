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
    return @{@"transaction_details": result};
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        self.orderID = [dictionary objectOrNilForKey:@"order_id"];
        self.grossAmount = [dictionary objectOrNilForKey:@"gross_amount"];
    }
    return self;
}

- (instancetype)initWithOrderID:(NSString *)orderID grossAmount:(NSNumber *)grossAmount {
    if (self = [super init]) {
        self.orderID = orderID;
        self.grossAmount = grossAmount;
    }
    return self;
}

@end
