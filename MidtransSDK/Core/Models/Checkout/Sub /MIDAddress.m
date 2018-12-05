//
//  MIDAddress.m
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 10/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import "MIDAddress.h"
#import "MIDModelHelper.h"

@implementation MIDAddress

- (NSDictionary *)dictionaryValue {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    [result setValue:self.firstName forKey:@"first_name"];
    [result setValue:self.lastName forKey:@"last_name"];
    [result setValue:self.email forKey:@"email"];
    [result setValue:self.phone forKey:@"phone"];
    [result setValue:self.address forKey:@"address"];
    [result setValue:self.city forKey:@"city"];
    [result setValue:self.postalCode forKey:@"postal_code"];
    [result setValue:self.countryCode forKey:@"country_code"];
    return result;
}

- (instancetype)initWithFirstName:(NSString *)firstName
                         lastName:(NSString *)lastName
                            email:(NSString *)email
                            phone:(NSString *)phone
                          address:(NSString *)address
                             city:(NSString *)city
                       postalCode:(NSString *)postalCode
                      countryCode:(NSString *)countryCode {
    if (self = [super init]) {
        self.firstName = firstName;
        self.lastName = lastName;
        self.email = email;
        self.phone = phone;
        self.address = address;
        self.city = city;
        self.postalCode = postalCode;
        self.countryCode = countryCode;
    }
    return self;
}

@end
