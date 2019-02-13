//
//  MIDItemDetails.m
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 19/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import "MIDCheckoutItems.h"
#import "MIDModelHelper.h"

@implementation MIDCheckoutItems

- (NSDictionary *)dictionaryValue {
    NSArray *values = [self.items dictionaryValues];
    if (values) {
        return @{@"item_details": values};
    } else {
        return nil;
    }    
}

- (instancetype)initWithItems:(NSArray <MIDItem *> *)items {
    if (self = [super init]) {
        self.items = items;
    }
    return self;
}

@end
