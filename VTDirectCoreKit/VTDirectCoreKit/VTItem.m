//
//  VTItem.m
//  VTDirectCoreKit
//
//  Created by Nanang Rafsanjani on 2/16/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTItem.h"

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
                  quantity:(NSNumber *)quantity {
    VTItem *item = [[VTItem alloc] init];
    item.itemId = itemId;
    item.price = price;
    item.quantity = quantity;
    item.name = name;
    return item;
}

@end
