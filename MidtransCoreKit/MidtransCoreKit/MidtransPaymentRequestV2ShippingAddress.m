//
//  MidtransPaymentRequestV2ShippingAddress.m
//
//  Created by Ratna Kumalasari on 10/25/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "MidtransPaymentRequestV2ShippingAddress.h"


NSString *const kMidtransPaymentRequestV2ShippingAddressCountryCode = @"country_code";
NSString *const kMidtransPaymentRequestV2ShippingAddressPhone = @"phone";
NSString *const kMidtransPaymentRequestV2ShippingAddressCity = @"city";
NSString *const kMidtransPaymentRequestV2ShippingAddressFirstName = @"first_name";
NSString *const kMidtransPaymentRequestV2ShippingAddressPostalCode = @"postal_code";


@interface MidtransPaymentRequestV2ShippingAddress ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation MidtransPaymentRequestV2ShippingAddress

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
            self.countryCode = [self objectOrNilForKey:kMidtransPaymentRequestV2ShippingAddressCountryCode fromDictionary:dict];
            self.phone = [self objectOrNilForKey:kMidtransPaymentRequestV2ShippingAddressPhone fromDictionary:dict];
            self.city = [self objectOrNilForKey:kMidtransPaymentRequestV2ShippingAddressCity fromDictionary:dict];
            self.firstName = [self objectOrNilForKey:kMidtransPaymentRequestV2ShippingAddressFirstName fromDictionary:dict];
            self.postalCode = [self objectOrNilForKey:kMidtransPaymentRequestV2ShippingAddressPostalCode fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.countryCode forKey:kMidtransPaymentRequestV2ShippingAddressCountryCode];
    [mutableDict setValue:self.phone forKey:kMidtransPaymentRequestV2ShippingAddressPhone];
    [mutableDict setValue:self.city forKey:kMidtransPaymentRequestV2ShippingAddressCity];
    [mutableDict setValue:self.firstName forKey:kMidtransPaymentRequestV2ShippingAddressFirstName];
    [mutableDict setValue:self.postalCode forKey:kMidtransPaymentRequestV2ShippingAddressPostalCode];

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

    self.countryCode = [aDecoder decodeObjectForKey:kMidtransPaymentRequestV2ShippingAddressCountryCode];
    self.phone = [aDecoder decodeObjectForKey:kMidtransPaymentRequestV2ShippingAddressPhone];
    self.city = [aDecoder decodeObjectForKey:kMidtransPaymentRequestV2ShippingAddressCity];
    self.firstName = [aDecoder decodeObjectForKey:kMidtransPaymentRequestV2ShippingAddressFirstName];
    self.postalCode = [aDecoder decodeObjectForKey:kMidtransPaymentRequestV2ShippingAddressPostalCode];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_countryCode forKey:kMidtransPaymentRequestV2ShippingAddressCountryCode];
    [aCoder encodeObject:_phone forKey:kMidtransPaymentRequestV2ShippingAddressPhone];
    [aCoder encodeObject:_city forKey:kMidtransPaymentRequestV2ShippingAddressCity];
    [aCoder encodeObject:_firstName forKey:kMidtransPaymentRequestV2ShippingAddressFirstName];
    [aCoder encodeObject:_postalCode forKey:kMidtransPaymentRequestV2ShippingAddressPostalCode];
}

- (id)copyWithZone:(NSZone *)zone
{
    MidtransPaymentRequestV2ShippingAddress *copy = [[MidtransPaymentRequestV2ShippingAddress alloc] init];
    
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
