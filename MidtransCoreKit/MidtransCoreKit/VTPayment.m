//
//  VTPayment.m
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 2/16/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTPayment.h"
#import "VTHelper.h"

#define OrderIdLength 10

@interface VTPayment()
@property (nonatomic, readwrite) VTUser *user;
@property (nonatomic, readwrite) NSString *orderId;
@property (nonatomic, readwrite) NSNumber *amount;
@end

@implementation VTPayment


- (id)initWithUser:(VTUser *)user amount:(NSNumber *)amount {
    if (self = [super init]) {
        self.user = user;
        self.amount = amount;
        self.orderId = [NSString randomWithLength:10];
    }
    return self;
}

- (NSDictionary *)transactionDetail {
    return @{@"order_id":self.orderId, @"gross_amount":self.amount};
}

@end