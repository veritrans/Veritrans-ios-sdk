//
//  MIDCheckoutRequest.m
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 10/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import "MIDCheckoutRequest.h"
#import "MIDModelHelper.h"

@implementation MIDCheckoutRequest

- (instancetype)initWithTransaction:(MIDTransaction *)transaction {
    if (self = [super init]) {
        self.transaction = transaction;
    }
    return self;
}

- (NSDictionary *)dictionaryValue {
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:self.transaction.dictionaryValue forKey:@"transaction_details"];
    
    if (self.customer) {
        [params setValue:self.transaction.dictionaryValue forKey:@"customer_details"];
    }
    
    if (self.items) {
        [params setValue:[self.items dictionaryValues] forKey:@"item_details"];
    }

    return params;
}

@end
