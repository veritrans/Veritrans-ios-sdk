//
//  VTAddress.m
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 2/16/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MidtransAddress.h"
#import "MidtransHelper.h"
#import "NSString+VTValidation.h"
#import "VTConstant.h"

@interface MidtransAddress ()

@property (nonatomic, readwrite) NSString *firstName;
@property (nonatomic, readwrite) NSString *lastName;
@property (nonatomic, readwrite) NSString *phone;
@property (nonatomic, readwrite) NSString *address;
@property (nonatomic, readwrite) NSString *city;
@property (nonatomic, readwrite) NSString *postalCode;
@property (nonatomic, readwrite) NSString *countryCode;

@end

@implementation MidtransAddress

- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.firstName forKey:@"firstName"];
    [encoder encodeObject:self.lastName forKey:@"lastName"];
    [encoder encodeObject:self.phone forKey:@"phone"];
    [encoder encodeObject:self.address forKey:@"address"];
    [encoder encodeObject:self.city forKey:@"city"];
    [encoder encodeObject:self.postalCode forKey:@"postalCode"];
    [encoder encodeObject:self.countryCode forKey:@"countryCode"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.firstName = [decoder decodeObjectForKey:@"firstName"];
        self.lastName = [decoder decodeObjectForKey:@"lastName"];
        self.phone = [decoder decodeObjectForKey:@"phone"];
        self.address = [decoder decodeObjectForKey:@"address"];
        self.city = [decoder decodeObjectForKey:@"city"];
        self.postalCode = [decoder decodeObjectForKey:@"postalCode"];
        self.countryCode = [decoder decodeObjectForKey:@"countryCode"];
    }
    return self;
}

+ (instancetype)addressWithFirstName:(NSString *)firstName
                            lastName:(NSString *)lastName
                               phone:(NSString *)phone
                             address:(NSString *)address
                                city:(NSString *)city
                          postalCode:(NSString *)postalCode
                         countryCode:(NSString *)countryCode {
    MidtransAddress *addr = [[MidtransAddress alloc] init];
    addr.firstName = firstName;
    addr.lastName = lastName;
    addr.phone = phone;
    addr.address = address;
    addr.city = city;
    addr.postalCode = postalCode;
    addr.countryCode = countryCode;
    return addr;
}

- (NSDictionary *)dictionaryValue {
    return @{@"first_name":[MidtransHelper nullifyIfNil:_firstName],
             @"last_name":[MidtransHelper nullifyIfNil:_lastName],
             @"phone":[MidtransHelper nullifyIfNil:_phone],
             @"address":[MidtransHelper nullifyIfNil:_address],
             @"city":[MidtransHelper nullifyIfNil:_city],
             @"postal_code":[MidtransHelper nullifyIfNil:_postalCode],
             @"country_code":[MidtransHelper nullifyIfNil:_countryCode]};
}

- (BOOL)validCustomerData:(NSError **)error {
    if (!self.phone.isEmpty && self.phone.isValidPhoneNumber) {
        return YES;
    }
    else {
        *error = [NSError errorWithDomain:VT_ERROR_DOMAIN code:VT_ERROR_CODE_INVALID_CUSTOMER_DETAILS userInfo:@{NSLocalizedDescriptionKey:NSLocalizedString(@"Invalid or missing customer credentials", nil)}];
        return NO;
    }
}

@end
