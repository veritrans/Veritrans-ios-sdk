//
//  VTHelper.m
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 2/18/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTHelper.h"
#import "VTItem.h"

@implementation VTHelper

+ (id)nullifyIfNil:(id)object {
    if (object) {
        return object;
    } else {
        return [NSNull null];
    }
}

@end

@implementation NSArray (item)

- (NSArray *)itemsRequestData {
    NSMutableArray *result = [NSMutableArray new];
    for (VTItem *item in self) {
        [result addObject:item.requestData];
    }
    return result;
}

- (NSNumber *)itemsPriceAmount {
    double result;
    for (VTItem *item in self) {
        result += (item.price.doubleValue * item.quantity.integerValue);
    }
    return @(result);
}

@end

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