//
//  MIDItemsInfo.m
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 13/02/19.
//  Copyright © 2019 Midtrans. All rights reserved.
//

#import "MIDItemInfo.h"
#import "MIDModelHelper.h"

@implementation MIDItemInfo

- (NSDictionary *)dictionaryValue {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    [result setValue:self.itemID forKey:@"id"];
    [result setValue:self.price forKey:@"price"];
    [result setValue:@(self.quantity) forKey:@"quantity"];
    [result setValue:self.name forKey:@"name"];
    return result;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        self.itemID = [dictionary objectOrNilForKey:@"id"];
        self.price = [dictionary objectOrNilForKey:@"price"];
        self.quantity = [[dictionary objectOrNilForKey:@"quantity"] integerValue];
        self.name = [dictionary objectOrNilForKey:@"name"];
    }
    return self;
}

@end
