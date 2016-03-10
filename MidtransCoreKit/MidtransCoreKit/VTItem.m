//
//  VTItem.m
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 2/16/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTItem.h"
#import "VTHelper.h"

@interface VTItem ()
@property(nonatomic, readwrite) NSString* itemId;
@property(nonatomic, readwrite) NSNumber *price;
@property(nonatomic, readwrite) NSNumber *quantity;
@property(nonatomic, readwrite) NSString* name;
@property(nonatomic, readwrite) NSString* imageURL;
@end

@implementation VTItem

+ (instancetype)itemWithId:(NSString *)itemId
                      name:(NSString *)name
                     price:(NSNumber *)price
                  imageURL:(NSString *)imageURL
                  quantity:(NSNumber *)quantity
{
    VTItem *item = [[VTItem alloc] init];
    item.itemId = itemId;
    item.price = price;
    item.quantity = quantity;
    item.name = name;
    item.imageURL = imageURL;
    return item;
}

- (NSDictionary *)requestData {
    return @{@"id":[VTHelper nullifyIfNil:_itemId],
             @"price":[VTHelper nullifyIfNil:_price],
             @"quantity":[VTHelper nullifyIfNil:_quantity],
             @"name":[VTHelper nullifyIfNil:_name],
             @"image":[VTHelper nullifyIfNil:_imageURL]};
}

@end
