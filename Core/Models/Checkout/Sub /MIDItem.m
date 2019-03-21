//
//  MIDItem.m
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 10/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import "MIDItem.h"
#import "MIDModelHelper.h"

@implementation MIDItem

- (NSDictionary *)dictionaryValue { 
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    [result setValue:self.itemID forKey:@"id"];
    [result setValue:self.price forKey:@"price"];
    [result setValue:@(self.quantity) forKey:@"quantity"];
    [result setValue:self.name forKey:@"name"];
    [result setValue:self.brand forKey:@"brand"];
    [result setValue:self.category forKey:@"category"];
    [result setValue:self.merchantName forKey:@"merchant_name"];
    return result;
}

- (instancetype)initWithID:(NSString *)itemID
                     price:(NSNumber * _Nonnull)price
                  quantity:(NSInteger)quantity
                      name:(NSString * _Nonnull)name
                     brand:(NSString *)brand
                  category:(NSString *)category
              merchantName:(NSString *)merchantName {
    if (self = [super init]) {
        self.itemID = itemID;
        self.price = price;
        self.quantity = quantity;
        self.name = name;
        self.brand = brand;
        self.category = category;
        self.merchantName = merchantName;
    }
    return self;
}

@end
