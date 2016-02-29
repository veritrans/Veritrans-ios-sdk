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
@property (nonatomic, readwrite) NSArray <VTItem *> *items;
@property (nonatomic, readwrite) NSNumber *totalPayment;
@property (nonatomic, readwrite) NSString *orderId;
@property (nonatomic, readwrite) NSNumber *grossAmount;
@end

@implementation VTPayment

+ (instancetype)paymentWithUser:(VTUser *)user andItems:(NSArray *)items {
    VTPayment *payment = [VTPayment new];
    payment.user = user;
    payment.items = items;
    payment.grossAmount = [payment grossAmountOfItems:items];
    return payment;
}

- (NSNumber *)grossAmountOfItems:(NSArray *)items {
    double amount = 0;
    for (VTItem *item in items) {
        amount += (item.price.doubleValue * item.quantity.integerValue);
    }
    return @(amount);
}

- (NSDictionary *)transactionDetail {
    return @{@"order_id":self.orderId, @"gross_amount":self.grossAmount};
}

@end