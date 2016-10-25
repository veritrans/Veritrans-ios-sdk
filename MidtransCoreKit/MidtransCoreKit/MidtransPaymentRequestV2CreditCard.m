//
//  MidtransPaymentRequestV2CreditCard.m
//
//  Created by Ratna Kumalasari on 10/25/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "MidtransPaymentRequestV2CreditCard.h"


NSString *const kMidtransPaymentRequestV2CreditCardSecure = @"secure";
NSString *const kMidtransPaymentRequestV2CreditCardWhitelistBins = @"whitelist_bins";
NSString *const kMidtransPaymentRequestV2CreditCardSaveCard = @"save_card";


@interface MidtransPaymentRequestV2CreditCard ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation MidtransPaymentRequestV2CreditCard

@synthesize secure = _secure;
@synthesize whitelistBins = _whitelistBins;
@synthesize saveCard = _saveCard;


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
            self.secure = [[self objectOrNilForKey:kMidtransPaymentRequestV2CreditCardSecure fromDictionary:dict] boolValue];
            self.whitelistBins = [self objectOrNilForKey:kMidtransPaymentRequestV2CreditCardWhitelistBins fromDictionary:dict];
            self.saveCard = [[self objectOrNilForKey:kMidtransPaymentRequestV2CreditCardSaveCard fromDictionary:dict] boolValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithBool:self.secure] forKey:kMidtransPaymentRequestV2CreditCardSecure];
    NSMutableArray *tempArrayForWhitelistBins = [NSMutableArray array];
    for (NSObject *subArrayObject in self.whitelistBins) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForWhitelistBins addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForWhitelistBins addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForWhitelistBins] forKey:kMidtransPaymentRequestV2CreditCardWhitelistBins];
    [mutableDict setValue:[NSNumber numberWithBool:self.saveCard] forKey:kMidtransPaymentRequestV2CreditCardSaveCard];

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

    self.secure = [aDecoder decodeBoolForKey:kMidtransPaymentRequestV2CreditCardSecure];
    self.whitelistBins = [aDecoder decodeObjectForKey:kMidtransPaymentRequestV2CreditCardWhitelistBins];
    self.saveCard = [aDecoder decodeBoolForKey:kMidtransPaymentRequestV2CreditCardSaveCard];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeBool:_secure forKey:kMidtransPaymentRequestV2CreditCardSecure];
    [aCoder encodeObject:_whitelistBins forKey:kMidtransPaymentRequestV2CreditCardWhitelistBins];
    [aCoder encodeBool:_saveCard forKey:kMidtransPaymentRequestV2CreditCardSaveCard];
}

- (id)copyWithZone:(NSZone *)zone
{
    MidtransPaymentRequestV2CreditCard *copy = [[MidtransPaymentRequestV2CreditCard alloc] init];
    
    if (copy) {

        copy.secure = self.secure;
        copy.whitelistBins = [self.whitelistBins copyWithZone:zone];
        copy.saveCard = self.saveCard;
    }
    
    return copy;
}


@end
