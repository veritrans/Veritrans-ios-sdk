//
//  MidtransPaymentRequestV2ShippingAddress.m
//
//  Created by Ratna Kumalasari on 10/25/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "MidtransPaymentRequestV2ShippingAddress.h"


NSString *const kMidtransPaymentRequestV2ShippingAddressCountryCode = @"country_code";


@interface MidtransPaymentRequestV2ShippingAddress ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation MidtransPaymentRequestV2ShippingAddress

@synthesize countryCode = _countryCode;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.countryCode = [self objectOrNilForKey:kMidtransPaymentRequestV2ShippingAddressCountryCode fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.countryCode forKey:kMidtransPaymentRequestV2ShippingAddressCountryCode];

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
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_countryCode forKey:kMidtransPaymentRequestV2ShippingAddressCountryCode];
}

- (id)copyWithZone:(NSZone *)zone
{
    MidtransPaymentRequestV2ShippingAddress *copy = [[MidtransPaymentRequestV2ShippingAddress alloc] init];
    
    if (copy) {

        copy.countryCode = [self.countryCode copyWithZone:zone];
    }
    
    return copy;
}


@end
