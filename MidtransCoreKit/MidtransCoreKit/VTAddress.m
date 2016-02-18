//
//  VTAddress.m
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 2/16/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTAddress.h"
#import "VTHelper.h"

@interface VTAddress ()
@property (nonatomic, readwrite) NSString *firstName;
@property (nonatomic, readwrite) NSString *lastName;
@property (nonatomic, readwrite) NSString *email;
@property (nonatomic, readwrite) NSString *phone;
@property (nonatomic, readwrite) NSString *address;
@property (nonatomic, readwrite) NSString *city;
@property (nonatomic, readwrite) NSString *postalCode;
@property (nonatomic, readwrite) NSString *countryCode;
@end

@implementation VTAddress

+ (instancetype)addressWithName:(NSString *)firstName
                       lastName:(NSString *)lastName
                          email:(NSString *)email
                          phone:(NSString *)phone
                        address:(NSString *)address
                           city:(NSString *)city
                     postalCode:(NSString *)postalCode
                    countryCode:(NSString *)countryCode
{
    VTAddress *addr = [[VTAddress alloc] init];
    addr.firstName = firstName;
    addr.lastName = lastName;
    addr.email = email;
    addr.phone = phone;
    addr.address = address;
    addr.city = city;
    addr.postalCode = postalCode;
    addr.countryCode = countryCode;
    return addr;
}

- (NSDictionary *)requestData {
    return @{@"first_name":[VTHelper nullifyIfNil:_firstName],
             @"last_name":[VTHelper nullifyIfNil:_lastName],
             @"address":[VTHelper nullifyIfNil:_address],
             @"city":[VTHelper nullifyIfNil:_city],
             @"postal_code":[VTHelper nullifyIfNil:_postalCode],
             @"phone":[VTHelper nullifyIfNil:_phone],
             @"country_code":[VTHelper nullifyIfNil:_countryCode]};
}

@end
