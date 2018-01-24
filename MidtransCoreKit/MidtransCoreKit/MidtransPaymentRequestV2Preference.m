//
//  MidtransPaymentRequestV2Preference.m
//
//  Created by Ratna Kumalasari on 10/25/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "MidtransPaymentRequestV2Preference.h"


NSString *const kMidtransPaymentRequestV2PreferenceLocale = @"locale";
NSString *const kMidtransPaymentRequestV2PreferenceFinishUrl = @"finish_url";
NSString *const kMidtransPaymentRequestV2PreferenceColorSchemeUrl = @"color_scheme_url";
NSString *const kMidtransPaymentRequestV2PreferencePendingUrl = @"pending_url";
NSString *const kMidtransPaymentRequestV2PreferenceColorScheme = @"color_scheme";
NSString *const kMidtransPaymentRequestV2PreferenceDisplayName = @"display_name";
NSString *const kMidtransPaymentRequestV2PreferenceErrorUrl = @"error_url";
NSString *const kMidtransPaymentRequestV2PreferenceLogoUrl = @"logo_url";
NSString *const kMidtransPaymentRequestV2PreferenceOtherVAProcessor = @"other_va_processor";


@interface MidtransPaymentRequestV2Preference ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation MidtransPaymentRequestV2Preference

@synthesize locale = _locale;
@synthesize finishUrl = _finishUrl;
@synthesize colorSchemeUrl = _colorSchemeUrl;
@synthesize pendingUrl = _pendingUrl;
@synthesize colorScheme = _colorScheme;
@synthesize displayName = _displayName;
@synthesize errorUrl = _errorUrl;
@synthesize logoUrl = _logoUrl;
@synthesize otherVAProcessor = _otherVAProcessor;

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
        self.locale = [self objectOrNilForKey:kMidtransPaymentRequestV2PreferenceLocale fromDictionary:dict];
        self.finishUrl = [self objectOrNilForKey:kMidtransPaymentRequestV2PreferenceFinishUrl fromDictionary:dict];
        self.colorSchemeUrl = [self objectOrNilForKey:kMidtransPaymentRequestV2PreferenceColorSchemeUrl fromDictionary:dict];
        self.pendingUrl = [self objectOrNilForKey:kMidtransPaymentRequestV2PreferencePendingUrl fromDictionary:dict];
        self.colorScheme = [self objectOrNilForKey:kMidtransPaymentRequestV2PreferenceColorScheme fromDictionary:dict];
        self.displayName = [self objectOrNilForKey:kMidtransPaymentRequestV2PreferenceDisplayName fromDictionary:dict];
        self.errorUrl = [self objectOrNilForKey:kMidtransPaymentRequestV2PreferenceErrorUrl fromDictionary:dict];
        self.logoUrl = [self objectOrNilForKey:kMidtransPaymentRequestV2PreferenceLogoUrl fromDictionary:dict];
        self.otherVAProcessor = [self objectOrNilForKey:kMidtransPaymentRequestV2PreferenceOtherVAProcessor fromDictionary:dict];
    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.locale forKey:kMidtransPaymentRequestV2PreferenceLocale];
    [mutableDict setValue:self.finishUrl forKey:kMidtransPaymentRequestV2PreferenceFinishUrl];
    [mutableDict setValue:self.colorSchemeUrl forKey:kMidtransPaymentRequestV2PreferenceColorSchemeUrl];
    [mutableDict setValue:self.pendingUrl forKey:kMidtransPaymentRequestV2PreferencePendingUrl];
    [mutableDict setValue:self.colorScheme forKey:kMidtransPaymentRequestV2PreferenceColorScheme];
    [mutableDict setValue:self.displayName forKey:kMidtransPaymentRequestV2PreferenceDisplayName];
    [mutableDict setValue:self.otherVAProcessor forKey:kMidtransPaymentRequestV2PreferenceOtherVAProcessor];
    [mutableDict setValue:self.errorUrl forKey:kMidtransPaymentRequestV2PreferenceErrorUrl];
    [mutableDict setValue:self.logoUrl forKey:kMidtransPaymentRequestV2PreferenceLogoUrl];
    
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
    
    self.locale = [aDecoder decodeObjectForKey:kMidtransPaymentRequestV2PreferenceLocale];
    self.finishUrl = [aDecoder decodeObjectForKey:kMidtransPaymentRequestV2PreferenceFinishUrl];
    self.colorSchemeUrl = [aDecoder decodeObjectForKey:kMidtransPaymentRequestV2PreferenceColorSchemeUrl];
    self.pendingUrl = [aDecoder decodeObjectForKey:kMidtransPaymentRequestV2PreferencePendingUrl];
    self.colorScheme = [aDecoder decodeObjectForKey:kMidtransPaymentRequestV2PreferenceColorScheme];
    self.displayName = [aDecoder decodeObjectForKey:kMidtransPaymentRequestV2PreferenceDisplayName];
    self.errorUrl = [aDecoder decodeObjectForKey:kMidtransPaymentRequestV2PreferenceErrorUrl];
    self.logoUrl = [aDecoder decodeObjectForKey:kMidtransPaymentRequestV2PreferenceLogoUrl];
    self.otherVAProcessor = [aDecoder decodeObjectForKey:kMidtransPaymentRequestV2PreferenceOtherVAProcessor];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
    [aCoder encodeObject:_locale forKey:kMidtransPaymentRequestV2PreferenceLocale];
    [aCoder encodeObject:_finishUrl forKey:kMidtransPaymentRequestV2PreferenceFinishUrl];
    [aCoder encodeObject:_colorSchemeUrl forKey:kMidtransPaymentRequestV2PreferenceColorSchemeUrl];
    [aCoder encodeObject:_pendingUrl forKey:kMidtransPaymentRequestV2PreferencePendingUrl];
    [aCoder encodeObject:_colorScheme forKey:kMidtransPaymentRequestV2PreferenceColorScheme];
    [aCoder encodeObject:_displayName forKey:kMidtransPaymentRequestV2PreferenceDisplayName];
    [aCoder encodeObject:_errorUrl forKey:kMidtransPaymentRequestV2PreferenceErrorUrl];
    [aCoder encodeObject:_logoUrl forKey:kMidtransPaymentRequestV2PreferenceLogoUrl];
}

- (id)copyWithZone:(NSZone *)zone
{
    MidtransPaymentRequestV2Preference *copy = [[MidtransPaymentRequestV2Preference alloc] init];
    
    if (copy) {
        
        copy.locale = [self.locale copyWithZone:zone];
        copy.finishUrl = [self.finishUrl copyWithZone:zone];
        copy.colorSchemeUrl = [self.colorSchemeUrl copyWithZone:zone];
        copy.pendingUrl = [self.pendingUrl copyWithZone:zone];
        copy.colorScheme = [self.colorScheme copyWithZone:zone];
        copy.displayName = [self.displayName copyWithZone:zone];
        copy.errorUrl = [self.errorUrl copyWithZone:zone];
        copy.logoUrl = [self.logoUrl copyWithZone:zone];
    }
    
    return copy;
}


@end
