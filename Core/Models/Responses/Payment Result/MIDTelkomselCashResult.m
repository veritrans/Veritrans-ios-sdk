//
//  MIDTelkomselCashResult.m
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 20/02/19.
//  Copyright © 2019 Midtrans. All rights reserved.
//

#import "MIDTelkomselCashResult.h"

@implementation MIDTelkomselCashResult

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super initWithDictionary:dictionary]) {
        self.settlementTime = [dictionary objectOrNilForKey:@"settlement_time"];
    }
    return self;
}

- (NSDictionary *)dictionaryValue {
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary:[super dictionaryValue]];
    [result setValue:self.settlementTime forKey:@"settlement_time"];
    return result;
}

@end
