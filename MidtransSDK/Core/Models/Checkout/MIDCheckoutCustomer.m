//
//  MIDCustomer.m
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 10/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import "MIDCheckoutCustomer.h"
#import "MIDModelHelper.h"

@implementation MIDCheckoutCustomer

- (NSDictionary *)dictionaryValue {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    [result setValue:self.firstName forKey:@"first_name"];
    [result setValue:self.lastName forKey:@"last_name"];
    [result setValue:self.email forKey:@"email"];
    [result setValue:self.phone forKey:@"phone"];
    [result setValue:[self.billingAddress dictionaryValue] forKey:@"billing_address"];
    [result setValue:[self.shippingAddress dictionaryValue] forKey:@"shipping_address"];
    return @{@"customer_details": result};
}

- (instancetype)initWithFirstName:(NSString *)firstName
                         lastName:(NSString *)lastName
                            email:(NSString *)email
                            phone:(NSString *)phone
                   billingAddress:(MIDAddress *)billingAddress
                  shippingAddress:(MIDAddress *)shippingAddress {
    if (self = [super init]) {
        self.firstName = firstName;
        self.lastName = lastName;
        self.email = email;
        self.phone = phone;
        self.billingAddress = billingAddress;
        self.shippingAddress = shippingAddress;
    }
    return self;
}

@end
