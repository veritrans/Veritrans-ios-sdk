//
//  SNPFreeTextPayment.m
//
//  Created by Ratna Kumalasari on 5/25/17
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "SNPFreeTextPayment.h"


NSString *const kSNPFreeTextPaymentId = @"id";
NSString *const kSNPFreeTextPaymentEn = @"en";


@interface SNPFreeTextPayment ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation SNPFreeTextPayment

@synthesize paymentIdentifier = _paymentIdentifier;
@synthesize en = _en;


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
            self.paymentIdentifier = [self objectOrNilForKey:kSNPFreeTextPaymentId fromDictionary:dict];
            self.en = [self objectOrNilForKey:kSNPFreeTextPaymentEn fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.paymentIdentifier forKey:kSNPFreeTextPaymentId];
    [mutableDict setValue:self.en forKey:kSNPFreeTextPaymentEn];

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

    self.paymentIdentifier = [aDecoder decodeObjectForKey:kSNPFreeTextPaymentId];
    self.en = [aDecoder decodeObjectForKey:kSNPFreeTextPaymentEn];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_paymentIdentifier forKey:kSNPFreeTextPaymentId];
    [aCoder encodeObject:_en forKey:kSNPFreeTextPaymentEn];
}

- (id)copyWithZone:(NSZone *)zone
{
    SNPFreeTextPayment *copy = [[SNPFreeTextPayment alloc] init];
    
    if (copy) {

        copy.paymentIdentifier = [self.paymentIdentifier copyWithZone:zone];
        copy.en = [self.en copyWithZone:zone];
    }
    
    return copy;
}


@end
