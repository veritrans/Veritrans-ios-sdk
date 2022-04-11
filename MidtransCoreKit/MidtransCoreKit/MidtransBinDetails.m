//
//  MidtransBinDetails.m
//  MidtransCoreKit
//
//  Created by Muhammad Fauzi Masykur on 06/04/22.
//  Copyright © 2022 Midtrans. All rights reserved.
//

#import "MidtransBinDetails.h"

NSString *const kMidtransBinDetailsRegistrationRequired = @"registration_required";
NSString *const KMidtransBinDetailsCountryName = @"country_name";
NSString *const KMidtransBinDetailsCountryCode = @"country_code";
NSString *const KMidtransBinDetailsChannel = @"channel";
NSString *const KMidtransBinDetailsBrand = @"brand";
NSString *const KMidtransBinDetailsBinType = @"bin_type";
NSString *const KMidtransBinDetailsBinClass = @"bin_class";
NSString *const KMidtransBinDetailsBin = @"bin";
NSString *const KMidtransBinDetailsBankCode = @"bank_code";
NSString *const KMidtransBinDetailsBank = @"bank";

@implementation MidtransBinDetails

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
        self.registrationRequired = [self objectOrNilForKey:kMidtransBinDetailsRegistrationRequired fromDictionary:dict];
        self.countryName = [self objectOrNilForKey:KMidtransBinDetailsCountryName fromDictionary:dict];
        self.countryCode = [self objectOrNilForKey:KMidtransBinDetailsCountryCode fromDictionary:dict];
        self.channel = [self objectOrNilForKey:KMidtransBinDetailsChannel fromDictionary:dict];
        self.brand = [self objectOrNilForKey:KMidtransBinDetailsBrand fromDictionary:dict];
        self.binType = [self objectOrNilForKey:KMidtransBinDetailsBinType fromDictionary:dict];
        self.binClass = [self objectOrNilForKey:KMidtransBinDetailsBinClass fromDictionary:dict];
        self.bin = [self objectOrNilForKey:KMidtransBinDetailsBin fromDictionary:dict];
        self.bankCode = [self objectOrNilForKey:KMidtransBinDetailsBankCode fromDictionary:dict];
        self.bank = [self objectOrNilForKey:KMidtransBinDetailsBank fromDictionary:dict];
    }
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.registrationRequired forKey:kMidtransBinDetailsRegistrationRequired];
    [mutableDict setValue:self.countryName forKey:KMidtransBinDetailsCountryName];
    [mutableDict setValue:self.countryCode forKey:KMidtransBinDetailsCountryCode];
    [mutableDict setValue:self.channel forKey:KMidtransBinDetailsChannel];
    [mutableDict setValue:self.brand forKey:KMidtransBinDetailsBrand];
    [mutableDict setValue:self.binType forKey:KMidtransBinDetailsBinType];
    [mutableDict setValue:self.binClass forKey:KMidtransBinDetailsBinClass];
    [mutableDict setValue:self.bin forKey:KMidtransBinDetailsBin];
    [mutableDict setValue:self.bankCode forKey:KMidtransBinDetailsBankCode];
    [mutableDict setValue:self.bank forKey:KMidtransBinDetailsBank];
    
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
    
    self.registrationRequired = [aDecoder decodeObjectForKey:kMidtransBinDetailsRegistrationRequired];
    self.countryName = [aDecoder decodeObjectForKey:KMidtransBinDetailsCountryName];
    self.countryCode = [aDecoder decodeObjectForKey:KMidtransBinDetailsCountryCode];
    self.channel = [aDecoder decodeObjectForKey:KMidtransBinDetailsChannel];
    self.brand = [aDecoder decodeObjectForKey:KMidtransBinDetailsBrand];
    self.binType = [aDecoder decodeObjectForKey:KMidtransBinDetailsBinType];
    self.binClass = [aDecoder decodeObjectForKey:KMidtransBinDetailsBinClass];
    self.bin = [aDecoder decodeObjectForKey:KMidtransBinDetailsBin];
    self.bankCode = [aDecoder decodeObjectForKey:KMidtransBinDetailsBankCode];
    self.bank = [aDecoder decodeObjectForKey:KMidtransBinDetailsBank];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
    [aCoder encodeObject:self.registrationRequired forKey:kMidtransBinDetailsRegistrationRequired];
    [aCoder encodeObject:self.countryName forKey:KMidtransBinDetailsCountryName];
    [aCoder encodeObject:self.countryCode forKey:KMidtransBinDetailsCountryCode];
    [aCoder encodeObject:self.channel forKey:KMidtransBinDetailsChannel];
    [aCoder encodeObject:self.brand forKey:KMidtransBinDetailsBrand];
    [aCoder encodeObject:self.binType forKey:KMidtransBinDetailsBinType];
    [aCoder encodeObject:self.binClass forKey:KMidtransBinDetailsBinClass];
    [aCoder encodeObject:self.bin forKey:KMidtransBinDetailsBin];
    [aCoder encodeObject:self.bankCode forKey:KMidtransBinDetailsBankCode];
    [aCoder encodeObject:self.bank forKey:KMidtransBinDetailsBank];
}

- (id)copyWithZone:(NSZone *)zone
{
    MidtransBinDetails *copy = [[MidtransBinDetails alloc] init];
    
    if (copy) {
        self.registrationRequired = [self.registrationRequired copyWithZone:zone];
        self.countryName = [self.countryName copyWithZone:zone];
        self.countryCode = [self.countryCode copyWithZone:zone];
        self.channel = [self.channel copyWithZone:zone];
        self.brand = [self.brand copyWithZone:zone];
        self.binType = [self.binType copyWithZone:zone];
        self.binClass = [self.binClass copyWithZone:zone];
        self.bin = [self.bin copyWithZone:zone];
        self.bankCode = [self.bankCode copyWithZone:zone];
        self.bank = [self.bank copyWithZone:zone];
    }
    
    return copy;
}

@end
