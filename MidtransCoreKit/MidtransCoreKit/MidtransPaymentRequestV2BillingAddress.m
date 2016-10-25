//
//  MidtransPaymentRequestV2BillingAddress.m
//
//  Created by Ratna Kumalasari on 10/25/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "MidtransPaymentRequestV2BillingAddress.h"


NSString *const kMidtransPaymentRequestV2BillingAddressCountryCode = @"country_code";


@interface MidtransPaymentRequestV2BillingAddress ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation MidtransPaymentRequestV2BillingAddress

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
            self.countryCode = [self objectOrNilForKey:kMidtransPaymentRequestV2BillingAddressCountryCode fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.countryCode forKey:kMidtransPaymentRequestV2BillingAddressCountryCode];

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
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_countryCode forKey:kMidtransPaymentRequestV2BillingAddressCountryCode];
}

- (id)copyWithZone:(NSZone *)zone
{
    MidtransPaymentRequestV2BillingAddress *copy = [[MidtransPaymentRequestV2BillingAddress alloc] init];
    
    if (copy) {

        copy.countryCode = [self.countryCode copyWithZone:zone];
    }
    
    return copy;
}


@end
