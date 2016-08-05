//
//  VTItem.m
//  iossdk-gojek
//
//  Created by Nanang Rafsanjani on 2/16/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTItemDetail.h"
#import "VTHelper.h"

@interface VTItemDetail ()
@property(nonatomic, readwrite) NSString* itemId;
@property(nonatomic, readwrite) NSNumber *price;
@property(nonatomic, readwrite) NSNumber *quantity;
@property(nonatomic, readwrite) NSString* name;
@end

@implementation VTItemDetail

- (instancetype)initWithItemID:(NSString *)itemID
                          name:(NSString *)name
                         price:(NSNumber *)price
                      quantity:(NSNumber *)quantity {
    if (self = [super init]) {
        self.itemId = itemID;
        self.name = name;
        self.price = price;
        self.quantity = quantity;
    }
    return self;
}

- (NSDictionary *)dictionaryValue {
    return @{@"id":[VTHelper nullifyIfNil:_itemId],
             @"price":[VTHelper nullifyIfNil:_price],
             @"quantity":[VTHelper nullifyIfNil:_quantity],
             @"name":[VTHelper nullifyIfNil:_name]};
}

@end
