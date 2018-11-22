//
//  MIDItemDetails.m
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 19/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import "MIDCheckoutItem.h"
#import "MIDModelHelper.h"

@implementation MIDCheckoutItem

- (NSDictionary *)dictionaryValue {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    [result setValue:[self.items dictionaryValues] forKey:@"item_details"];
    return @{@"item_details": result};
}

- (instancetype)initWithItems:(NSArray <MIDItem *> *)items {
    if (self = [super init]) {
        self.items = items;
    }
    return self;
}

@end
