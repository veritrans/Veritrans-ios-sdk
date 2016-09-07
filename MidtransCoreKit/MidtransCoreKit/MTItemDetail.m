//
//  VTItem.m
//  iossdk-gojek
//
//  Created by Nanang Rafsanjani on 2/16/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MTItemDetail.h"
#import "MTHelper.h"

@implementation NSArray (VTITemDetail)

- (NSArray *)itemDetailsDictionaryValue {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [self enumerateObjectsUsingBlock:^(MTItemDetail * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [result addObject:[obj dictionaryValue]];
    }];
    return result;
}

@end

@interface MTItemDetail ()
@property(nonatomic, readwrite) NSString *itemId;
@property(nonatomic, readwrite) NSNumber *price;
@property(nonatomic, readwrite) NSNumber *quantity;
@property(nonatomic, readwrite) NSString *name;
@end

@implementation MTItemDetail

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
    return @{@"id":[MTHelper nullifyIfNil:_itemId],
             @"price":[MTHelper nullifyIfNil:_price],
             @"quantity":[MTHelper nullifyIfNil:_quantity],
             @"name":[MTHelper nullifyIfNil:_name]};
}

@end
