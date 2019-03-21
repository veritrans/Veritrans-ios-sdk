//
//  MIDPointResponse.m
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 03/01/19.
//  Copyright © 2019 Midtrans. All rights reserved.
//

#import "MIDPointResponse.h"
#import "MIDModelHelper.h"

@implementation MIDPointResponse

- (NSDictionary *)dictionaryValue {
    NSMutableDictionary *result = [NSMutableDictionary new];
    [result setValue:self.balance forKey:@"point_balance"];
    [result setValue:self.balanceAmount forKey:@"point_balance_amount"];
    [result setValue:self.balanceQuantity forKey:@"point_balance_quantity"];
    [result setValue:self.statusCode forKey:@"status_code"];
    [result setValue:self.statusMessage forKey:@"status_message"];
    [result setValue:self.transactionTime forKey:@"transaction_time"];
    return result;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        self.balance = [dictionary objectOrNilForKey:@"point_balance"];
        self.balanceAmount = [dictionary objectOrNilForKey:@"point_balance_amount"];
        self.balanceQuantity = [dictionary objectOrNilForKey:@"point_balance_quantity"];
        self.statusCode = [dictionary objectOrNilForKey:@"status_code"];
        self.statusMessage = [dictionary objectOrNilForKey:@"status_message"];
        self.transactionTime = [dictionary objectOrNilForKey:@"transaction_time"];
    }
    return self;
}

@end
