//
//  MIDModelHelper.m
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 10/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import "MIDModelHelper.h"


@implementation NSDictionary (extract)

- (id)objectOrNilForKey:(id)key {
    id object = [self objectForKey:key];
    return [object isEqual:[NSNull null]] ? nil : object;
}

@end

@implementation NSArray (parse)

- (NSArray *)dictionaryValues {
    NSMutableArray *result = [NSMutableArray new];
    for (id mappable in self) {
        if ([mappable respondsToSelector:@selector(dictionaryValue)]) {
            [result addObject:[mappable dictionaryValue]];
        }
    }
    return result;
}

@end
