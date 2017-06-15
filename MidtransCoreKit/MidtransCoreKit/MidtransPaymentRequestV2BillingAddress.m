//
//  MidtransPaymentRequestV2BillingAddress.m
//
//  Created by Ratna Kumalasari on 10/25/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "MidtransPaymentRequestV2BillingAddress.h"


NSString *const kMidtransPaymentRequestV2BillingAddressCountryCode = @"country_code";
NSString *const kMidtransPaymentRequestV2BillingAddressPhone = @"phone";
NSString *const kMidtransPaymentRequestV2BillingAddressCity = @"city";
NSString *const kMidtransPaymentRequestV2BillingAddressFirstName = @"first_name";
NSString *const kMidtransPaymentRequestV2BillingAddressPostalCode = @"postal_code";


@interface MidtransPaymentRequestV2BillingAddress ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation MidtransPaymentRequestV2BillingAddress

@synthesize countryCode = _countryCode;
@synthesize phone = _phone;
@synthesize city = _city;
@synthesize firstName = _firstName;
@synthesize postalCode = _postalCode;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.countryCode = [self objectOrNilForKey:kMidtransPaymentRequestV2BillingAddressCountryCode fromDictionary:dict];
            self.phone = [self objectOrNilForKey:kMidtransPaymentRequestV2BillingAddressPhone fromDictionary:dict];
            self.city = [self objectOrNilForKey:kMidtransPaymentRequestV2BillingAddressCity fromDictionary:dict];
            self.firstName = [self objectOrNilForKey:kMidtransPaymentRequestV2BillingAddressFirstName fromDictionary:dict];
            self.postalCode = [self objectOrNilForKey:kMidtransPaymentRequestV2BillingAddressPostalCode fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.countryCode forKey:kMidtransPaymentRequestV2BillingAddressCountryCode];
    [mutableDict setValue:self.phone forKey:kMidtransPaymentRequestV2BillingAddressPhone];
    [mutableDict setValue:self.city forKey:kMidtransPaymentRequestV2BillingAddressCity];
    [mutableDict setValue:self.firstName forKey:kMidtransPaymentRequestV2BillingAddressFirstName];
    [mutableDict setValue:self.postalCode forKey:kMidtransPaymentRequestV2BillingAddressPostalCode];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description 
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    self.countryCode = [aDecoder decodeObjectForKey:kMidtransPaymentRequestV2BillingAddressCountryCode];
    self.phone = [aDecoder decodeObjectForKey:kMidtransPaymentRequestV2BillingAddressPhone];
    self.city = [aDecoder decodeObjectForKey:kMidtransPaymentRequestV2BillingAddressCity];
    self.firstName = [aDecoder decodeObjectForKey:kMidtransPaymentRequestV2BillingAddressFirstName];
    self.postalCode = [aDecoder decodeObjectForKey:kMidtransPaymentRequestV2BillingAddressPostalCode];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_countryCode forKey:kMidtransPaymentRequestV2BillingAddressCountryCode];
    [aCoder encodeObject:_phone forKey:kMidtransPaymentRequestV2BillingAddressPhone];
    [aCoder encodeObject:_city forKey:kMidtransPaymentRequestV2BillingAddressCity];
    [aCoder encodeObject:_firstName forKey:kMidtransPaymentRequestV2BillingAddressFirstName];
    [aCoder encodeObject:_postalCode forKey:kMidtransPaymentRequestV2BillingAddressPostalCode];
}

- (id)copyWithZone:(NSZone *)zone
{
    MidtransPaymentRequestV2BillingAddress *copy = [[MidtransPaymentRequestV2BillingAddress alloc] init];
    
    if (copy) {

        copy.countryCode = [self.countryCode copyWithZone:zone];
        copy.phone = [self.phone copyWithZone:zone];
        copy.city = [self.city copyWithZone:zone];
        copy.firstName = [self.firstName copyWithZone:zone];
        copy.postalCode = [self.postalCode copyWithZone:zone];
    }
    
    return copy;
}


@end
