//
//  MIDExbinData.m
//  MidtransCoreKit
//
//  Created by Muhammad Fauzi Masykur on 04/04/22.
//  Copyright © 2022 Midtrans. All rights reserved.
//

#import "MIDExbinData.h"

NSString *const KMidtransExbinDataCountryName = @"country_name";
NSString *const KMidtransExbinDataCountryCode = @"country_code";
NSString *const KMidtransExbinDataChannel = @"channel";
NSString *const KMidtransExbinDataBrand = @"brand";
NSString *const KMidtransExbinDataBinType = @"bin_type";
NSString *const KMidtransExbinDataBinClass = @"bin_class";
NSString *const KMidtransExbinDataBin = @"bin";
NSString *const KMidtransExbinDataBankCode = @"bank_code";
NSString *const KMidtransExbinDataBank = @"bank";

@implementation MIDExbinData

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
        self.countryName = [self objectOrNilForKey:KMidtransExbinDataCountryName fromDictionary:dict];
        self.countryCode = [self objectOrNilForKey:KMidtransExbinDataCountryCode fromDictionary:dict];
        self.channel = [self objectOrNilForKey:KMidtransExbinDataChannel fromDictionary:dict];
        self.brand = [self objectOrNilForKey:KMidtransExbinDataBrand fromDictionary:dict];
        self.binType = [self objectOrNilForKey:KMidtransExbinDataBinType fromDictionary:dict];
        self.binClass = [self objectOrNilForKey:KMidtransExbinDataBinClass fromDictionary:dict];
        self.bin = [self objectOrNilForKey:KMidtransExbinDataBin fromDictionary:dict];
        self.bankCode = [self objectOrNilForKey:KMidtransExbinDataBankCode fromDictionary:dict];
        self.bank = [self objectOrNilForKey:KMidtransExbinDataBank fromDictionary:dict];
    }
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.countryName forKey:KMidtransExbinDataCountryName];
    [mutableDict setValue:self.countryCode forKey:KMidtransExbinDataCountryCode];
    [mutableDict setValue:self.channel forKey:KMidtransExbinDataChannel];
    [mutableDict setValue:self.brand forKey:KMidtransExbinDataBrand];
    [mutableDict setValue:self.binType forKey:KMidtransExbinDataBinType];
    [mutableDict setValue:self.binClass forKey:KMidtransExbinDataBinClass];
    [mutableDict setValue:self.bin forKey:KMidtransExbinDataBin];
    [mutableDict setValue:self.bankCode forKey:KMidtransExbinDataBankCode];
    [mutableDict setValue:self.bank forKey:KMidtransExbinDataBank];
    
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
    
    self.countryName = [aDecoder decodeObjectForKey:KMidtransExbinDataCountryName];
    self.countryCode = [aDecoder decodeObjectForKey:KMidtransExbinDataCountryCode];
    self.channel = [aDecoder decodeObjectForKey:KMidtransExbinDataChannel];
    self.brand = [aDecoder decodeObjectForKey:KMidtransExbinDataBrand];
    self.binType = [aDecoder decodeObjectForKey:KMidtransExbinDataBinType];
    self.binClass = [aDecoder decodeObjectForKey:KMidtransExbinDataBinClass];
    self.bin = [aDecoder decodeObjectForKey:KMidtransExbinDataBin];
    self.bankCode = [aDecoder decodeObjectForKey:KMidtransExbinDataBankCode];
    self.bank = [aDecoder decodeObjectForKey:KMidtransExbinDataBank];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
    [aCoder encodeObject:self.countryName forKey:KMidtransExbinDataCountryName];
    [aCoder encodeObject:self.countryCode forKey:KMidtransExbinDataCountryCode];
    [aCoder encodeObject:self.channel forKey:KMidtransExbinDataChannel];
    [aCoder encodeObject:self.brand forKey:KMidtransExbinDataBrand];
    [aCoder encodeObject:self.binType forKey:KMidtransExbinDataBinType];
    [aCoder encodeObject:self.binClass forKey:KMidtransExbinDataBinClass];
    [aCoder encodeObject:self.bin forKey:KMidtransExbinDataBin];
    [aCoder encodeObject:self.bankCode forKey:KMidtransExbinDataBankCode];
    [aCoder encodeObject:self.bank forKey:KMidtransExbinDataBank];
}

- (id)copyWithZone:(NSZone *)zone
{
    MIDExbinData *copy = [[MIDExbinData alloc] init];
    
    if (copy) {
        
        
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
