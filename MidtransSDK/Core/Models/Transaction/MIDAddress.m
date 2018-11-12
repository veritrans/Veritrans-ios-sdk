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

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        self.firstName = [dictionary objectOrNilForKey:@"first_name"];
        self.lastName = [dictionary objectOrNilForKey:@"last_name"];
        self.email = [dictionary objectOrNilForKey:@"email"];
        self.phone = [dictionary objectOrNilForKey:@"phone"];
        self.address = [dictionary objectOrNilForKey:@"address"];
        self.city = [dictionary objectOrNilForKey:@"city"];
        self.postalCode = [dictionary objectOrNilForKey:@"postal_code"];
        self.countryCode = [dictionary objectOrNilForKey:@"country_code"];
    }
    return self;
}

@end
