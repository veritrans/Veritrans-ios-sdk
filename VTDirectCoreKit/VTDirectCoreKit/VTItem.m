//
//  VTItem.m
//  VTDirectCoreKit
//
//  Created by Nanang Rafsanjani on 2/16/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTItem.h"
#import "VTHelper.h"

@implementation NSArray (item)

- (NSArray *)convertItemsToRequestData {
    NSMutableArray *result = [NSMutableArray new];
    for (VTItem *item in self) {
        [result addObject:item.requestData];
    }
    return result;
}

- (NSNumber *)amount {
    double result;
    for (VTItem *item in self) {
        result += (item.price.doubleValue * item.quantity.integerValue);
    }
    return @(result);
}

@end

@interface VTItem ()
@property(nonatomic, readwrite) NSString* itemId;
@property(nonatomic, readwrite) NSNumber *price;
@property(nonatomic, readwrite) NSNumber *quantity;
@property(nonatomic, readwrite) NSString* name;
@end

@implementation VTItem

+ (instancetype)itemWithId:(NSString *)itemId
                      name:(NSString *)name
                     price:(NSNumber *)price
                  quantity:(NSNumber *)quantity
{
    VTItem *item = [[VTItem alloc] init];
    item.itemId = itemId;
    item.price = price;
    item.quantity = quantity;
    item.name = name;
    return item;
}

- (NSDictionary *)requestData {
    return @{@"id":[VTHelper nullifyIfNil:_itemId],
             @"price":[VTHelper nullifyIfNil:_price],
             @"quantity":[VTHelper nullifyIfNil:_quantity],
             @"name":[VTHelper nullifyIfNil:_name]};
}

@end
