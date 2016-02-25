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
@end

@implementation VTPayment

- (id)initWithItems:(NSArray *)items user:(VTUser *)user {
    if (self = [super init]) {
        self.items = items;
        self.user = user;
        self.orderId = [NSString randomWithLength:OrderIdLength];
    }
    return self;
}

@end