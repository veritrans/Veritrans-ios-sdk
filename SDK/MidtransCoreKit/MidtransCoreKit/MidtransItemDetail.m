//
//  VTItem.m
//  iossdk-gojek
//
//  Created by Nanang Rafsanjani on 2/16/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MidtransItemDetail.h"
#import "MidtransHelper.h"

@implementation NSArray (VTITemDetail)

- (NSArray *)itemDetailsDictionaryValue {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [self enumerateObjectsUsingBlock:^(MidtransItemDetail * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [result addObject:[obj dictionaryValue]];
    }];
    return result;
}

@end

@interface MidtransItemDetail ()
@property(nonatomic, readwrite) NSString *itemId;
@property(nonatomic, readwrite) NSNumber *price;
@property(nonatomic, readwrite) NSNumber *quantity;
@property(nonatomic, readwrite) NSString *name;
@end

@implementation MidtransItemDetail

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
    return @{@"id":[MidtransHelper nullifyIfNil:_itemId],
             @"price":[MidtransHelper nullifyIfNil:_price],
             @"quantity":[MidtransHelper nullifyIfNil:_quantity],
             @"name":[MidtransHelper nullifyIfNil:_name]};
}

@end
