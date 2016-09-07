//
//  PaymentRequestMerchantData.m
//
//  Created by Arie  on 7/19/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "MTPaymentRequestMerchantData.h"


NSString *const kPaymentRequestMerchantDataLocale = @"locale";
NSString *const kPaymentRequestMerchantDataClientKey = @"clientKey";
NSString *const kPaymentRequestMerchantDataDisplayName = @"displayName";
NSString *const kPaymentRequestMerchantDataLogoUrl = @"logoUrl";
NSString *const kPaymentRequestMerchantDataUnFinishUrl = @"unFinishUrl";
NSString *const kPaymentRequestMerchantDataErrorUrl = @"errorUrl";
NSString *const kPaymentRequestMerchantDataFinishUrl = @"finishUrl";
NSString *const kPaymentRequestMerchantDataColorScheme = @"colorScheme";


@interface MTPaymentRequestMerchantData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation MTPaymentRequestMerchantData

@synthesize locale = _locale;
@synthesize clientKey = _clientKey;
@synthesize displayName = _displayName;
@synthesize logoUrl = _logoUrl;
@synthesize unFinishUrl = _unFinishUrl;
@synthesize errorUrl = _errorUrl;
@synthesize finishUrl = _finishUrl;
@synthesize colorScheme = _colorScheme;


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
        self.locale = [self objectOrNilForKey:kPaymentRequestMerchantDataLocale fromDictionary:dict];
        self.clientKey = [self objectOrNilForKey:kPaymentRequestMerchantDataClientKey fromDictionary:dict];
        self.displayName = [self objectOrNilForKey:kPaymentRequestMerchantDataDisplayName fromDictionary:dict];
        self.logoUrl = [self objectOrNilForKey:kPaymentRequestMerchantDataLogoUrl fromDictionary:dict];
        self.unFinishUrl = [self objectOrNilForKey:kPaymentRequestMerchantDataUnFinishUrl fromDictionary:dict];
        self.errorUrl = [self objectOrNilForKey:kPaymentRequestMerchantDataErrorUrl fromDictionary:dict];
        self.finishUrl = [self objectOrNilForKey:kPaymentRequestMerchantDataFinishUrl fromDictionary:dict];
        self.colorScheme = [self objectOrNilForKey:kPaymentRequestMerchantDataColorScheme fromDictionary:dict];
        
    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.locale forKey:kPaymentRequestMerchantDataLocale];
    [mutableDict setValue:self.clientKey forKey:kPaymentRequestMerchantDataClientKey];
    [mutableDict setValue:self.displayName forKey:kPaymentRequestMerchantDataDisplayName];
    [mutableDict setValue:self.logoUrl forKey:kPaymentRequestMerchantDataLogoUrl];
    [mutableDict setValue:self.unFinishUrl forKey:kPaymentRequestMerchantDataUnFinishUrl];
    [mutableDict setValue:self.errorUrl forKey:kPaymentRequestMerchantDataErrorUrl];
    [mutableDict setValue:self.finishUrl forKey:kPaymentRequestMerchantDataFinishUrl];
    [mutableDict setValue:self.colorScheme forKey:kPaymentRequestMerchantDataColorScheme];
    
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
    
    self.locale = [aDecoder decodeObjectForKey:kPaymentRequestMerchantDataLocale];
    self.clientKey = [aDecoder decodeObjectForKey:kPaymentRequestMerchantDataClientKey];
    self.displayName = [aDecoder decodeObjectForKey:kPaymentRequestMerchantDataDisplayName];
    self.logoUrl = [aDecoder decodeObjectForKey:kPaymentRequestMerchantDataLogoUrl];
    self.unFinishUrl = [aDecoder decodeObjectForKey:kPaymentRequestMerchantDataUnFinishUrl];
    self.errorUrl = [aDecoder decodeObjectForKey:kPaymentRequestMerchantDataErrorUrl];
    self.finishUrl = [aDecoder decodeObjectForKey:kPaymentRequestMerchantDataFinishUrl];
    self.colorScheme = [aDecoder decodeObjectForKey:kPaymentRequestMerchantDataColorScheme];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
    [aCoder encodeObject:_locale forKey:kPaymentRequestMerchantDataLocale];
    [aCoder encodeObject:_clientKey forKey:kPaymentRequestMerchantDataClientKey];
    [aCoder encodeObject:_displayName forKey:kPaymentRequestMerchantDataDisplayName];
    [aCoder encodeObject:_logoUrl forKey:kPaymentRequestMerchantDataLogoUrl];
    [aCoder encodeObject:_unFinishUrl forKey:kPaymentRequestMerchantDataUnFinishUrl];
    [aCoder encodeObject:_errorUrl forKey:kPaymentRequestMerchantDataErrorUrl];
    [aCoder encodeObject:_finishUrl forKey:kPaymentRequestMerchantDataFinishUrl];
    [aCoder encodeObject:_colorScheme forKey:kPaymentRequestMerchantDataColorScheme];
}

- (id)copyWithZone:(NSZone *)zone
{
    MTPaymentRequestMerchantData *copy = [[MTPaymentRequestMerchantData alloc] init];
    
    if (copy) {
        
        copy.locale = [self.locale copyWithZone:zone];
        copy.clientKey = [self.clientKey copyWithZone:zone];
        copy.displayName = [self.displayName copyWithZone:zone];
        copy.logoUrl = [self.logoUrl copyWithZone:zone];
        copy.unFinishUrl = [self.unFinishUrl copyWithZone:zone];
        copy.errorUrl = [self.errorUrl copyWithZone:zone];
        copy.finishUrl = [self.finishUrl copyWithZone:zone];
        copy.colorScheme = [self.colorScheme copyWithZone:zone];
    }
    
    return copy;
}
- (NSString *)merchantName {
    return self.displayName;
}

@end
