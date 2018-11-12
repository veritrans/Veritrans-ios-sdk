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
    [result setValue:self.quantity forKey:@"quantity"];
    [result setValue:self.name forKey:@"name"];
    [result setValue:self.brand forKey:@"brand"];
    [result setValue:self.category forKey:@"category"];
    [result setValue:self.merchantName forKey:@"merchant_name"];
    return result;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary { 
    if (self = [super init]) {
        self.itemID = [dictionary objectOrNilForKey:@"id"];
        self.price = [dictionary objectOrNilForKey:@"price"];
        self.quantity = [dictionary objectOrNilForKey:@"quantity"];
        self.name = [dictionary objectOrNilForKey:@"name"];
        self.brand = [dictionary objectOrNilForKey:@"brand"];
        self.category = [dictionary objectOrNilForKey:@"category"];
        self.merchantName = [dictionary objectOrNilForKey:@"merchant_name"];
    }
    return self;
}

@end
