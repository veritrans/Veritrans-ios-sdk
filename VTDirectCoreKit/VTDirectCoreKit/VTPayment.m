//
//  VTPayment.m
//  VTDirectCoreKit
//
//  Created by Nanang Rafsanjani on 2/16/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTPayment.h"

#define OrderIdLength 10

@implementation NSString (random)

+ (NSString *)randomWithLength:(NSUInteger)length {
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity:length];
    for (int i=0; i<length; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform((int)[letters length])]];
    }
    return randomString;
}

@end

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