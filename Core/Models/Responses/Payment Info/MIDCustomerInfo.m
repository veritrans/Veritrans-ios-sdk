//
//  MIDCustomerInfo.m
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 13/02/19.
//  Copyright © 2019 Midtrans. All rights reserved.
//

#import "MIDCustomerInfo.h"
#import "MIDModelHelper.h"

@implementation MIDCustomerInfo

- (NSDictionary *)dictionaryValue {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    [result setValue:self.firstName forKey:@"first_name"];
    [result setValue:self.lastName forKey:@"last_name"];
    [result setValue:self.email forKey:@"email"];
    [result setValue:self.phone forKey:@"phone"];
    [result setValue:[self.billingAddress dictionaryValue] forKey:@"billing_address"];
    [result setValue:[self.shippingAddress dictionaryValue] forKey:@"shipping_address"];
    return result;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        self.firstName = [dictionary objectOrNilForKey:@"first_name"];
        self.lastName = [dictionary objectOrNilForKey:@"last_name"];
        self.email = [dictionary objectOrNilForKey:@"email"];
        self.phone = [dictionary objectOrNilForKey:@"phone"];
        self.billingAddress = [[MIDAddressInfo alloc] initWithDictionary:[dictionary objectOrNilForKey:@"billing_address"]];
        self.shippingAddress = [[MIDAddressInfo alloc] initWithDictionary:[dictionary objectOrNilForKey:@"shipping_address"]];
    }
    return self;
}

@end
