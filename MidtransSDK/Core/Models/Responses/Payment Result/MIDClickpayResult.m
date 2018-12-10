//
//  MIDClickpayResult.m
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 06/12/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import "MIDClickpayResult.h"

@implementation MIDClickpayResult

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super initWithDictionary:dictionary]) {
        self.approvalCode = [dictionary objectOrNilForKey:@"approval_code"];
        self.settlementTime = [dictionary objectOrNilForKey:@"settlement_time"];
        self.maskedCard = [dictionary objectOrNilForKey:@"masked_card"];
    }
    return self;
}

- (NSDictionary *)dictionaryValue {
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary:[super dictionaryValue]];
    [result setValue:self.approvalCode forKey:@"approval_code"];
    [result setValue:self.settlementTime forKey:@"settlement_time"];
    [result setValue:self.maskedCard forKey:@"masked_card"];
    return result;
}

@end
