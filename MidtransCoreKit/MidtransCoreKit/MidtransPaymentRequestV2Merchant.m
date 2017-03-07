//
//  MidtransPaymentRequestV2Merchant.m
//
//  Created by Ratna Kumalasari on 10/25/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "MidtransPaymentRequestV2Merchant.h"
#import "MidtransPaymentRequestV2Preference.h"


NSString *const kMidtransPaymentRequestV2MerchantClientKey = @"client_key";
NSString *const kMidtransPaymentRequestV2MerchantEnabledPrinciples = @"enabled_principles";
NSString *const kMidtransPaymentRequestV2MerchantPreference = @"preference";
NSString *const kMidtransPaymentRequestV2MerchantPointBanks = @"point_banks";


@interface MidtransPaymentRequestV2Merchant ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation MidtransPaymentRequestV2Merchant

@synthesize clientKey = _clientKey;
@synthesize enabledPrinciples = _enabledPrinciples;
@synthesize preference = _preference;


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
            self.clientKey = [self objectOrNilForKey:kMidtransPaymentRequestV2MerchantClientKey fromDictionary:dict];
            self.enabledPrinciples = [self objectOrNilForKey:kMidtransPaymentRequestV2MerchantEnabledPrinciples fromDictionary:dict];
        self.pointBanks = [self objectOrNilForKey:kMidtransPaymentRequestV2MerchantPointBanks fromDictionary:dict];
            self.preference = [MidtransPaymentRequestV2Preference modelObjectWithDictionary:[dict objectForKey:kMidtransPaymentRequestV2MerchantPreference]];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.clientKey forKey:kMidtransPaymentRequestV2MerchantClientKey];
    NSMutableArray *tempArrayForEnabledPrinciples = [NSMutableArray array];
    for (NSObject *subArrayObject in self.enabledPrinciples) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForEnabledPrinciples addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForEnabledPrinciples addObject:subArrayObject];
        }
    }
    NSMutableArray *tempArrayForPointBanks = [NSMutableArray array];
    for (NSObject *subArrayObject in self.pointBanks) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForPointBanks addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForPointBanks addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForEnabledPrinciples] forKey:kMidtransPaymentRequestV2MerchantEnabledPrinciples];
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForPointBanks] forKey:kMidtransPaymentRequestV2MerchantPointBanks];
    [mutableDict setValue:[self.preference dictionaryRepresentation] forKey:kMidtransPaymentRequestV2MerchantPreference];

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

    self.clientKey = [aDecoder decodeObjectForKey:kMidtransPaymentRequestV2MerchantClientKey];
    self.enabledPrinciples = [aDecoder decodeObjectForKey:kMidtransPaymentRequestV2MerchantEnabledPrinciples];
    self.preference = [aDecoder decodeObjectForKey:kMidtransPaymentRequestV2MerchantPreference];
    self.preference = [aDecoder decodeObjectForKey:kMidtransPaymentRequestV2MerchantPointBanks];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_clientKey forKey:kMidtransPaymentRequestV2MerchantClientKey];
    [aCoder encodeObject:_enabledPrinciples forKey:kMidtransPaymentRequestV2MerchantEnabledPrinciples];
    [aCoder encodeObject:_preference forKey:kMidtransPaymentRequestV2MerchantPreference];
    [aCoder encodeObject:_pointBanks forKey:kMidtransPaymentRequestV2MerchantPointBanks];
}

- (id)copyWithZone:(NSZone *)zone
{
    MidtransPaymentRequestV2Merchant *copy = [[MidtransPaymentRequestV2Merchant alloc] init];
    
    if (copy) {

        copy.clientKey = [self.clientKey copyWithZone:zone];
        copy.enabledPrinciples = [self.enabledPrinciples copyWithZone:zone];
        copy.preference = [self.preference copyWithZone:zone];
        copy.pointBanks = [self.pointBanks copyWithZone:zone];
    }
    
    return copy;
}


@end
