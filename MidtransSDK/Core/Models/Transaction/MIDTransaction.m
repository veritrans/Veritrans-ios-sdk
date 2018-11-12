//
//  MIDTransaction.m
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 10/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import "MIDTransaction.h"
#import "MIDModelHelper.h"

@implementation MIDTransaction

- (NSDictionary *)dictionaryValue {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    [result setValue:self.orderID forKey:@"order_id"];
    [result setValue:self.grossAmount forKey:@"gross_amount"];
    return result;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        self.orderID = [dictionary objectOrNilForKey:@"order_id"];
        self.grossAmount = [dictionary objectOrNilForKey:@"gross_amount"];
    }
    return self;
}

+ (instancetype)modelWithOrderID:(NSString *)orderID grossAmount:(NSNumber *)grossAmount {
    NSDictionary *dict = @{@"order_id": orderID,
                           @"gross_amount": grossAmount
                           };
    return [[MIDTransaction alloc] initWithDictionary:dict];
}

@end
