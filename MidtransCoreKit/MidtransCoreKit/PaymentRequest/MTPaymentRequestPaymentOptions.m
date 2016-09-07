//
//  PaymentRequestPaymentOptions.m
//
//  Created by Arie  on 7/19/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "MTPaymentRequestPaymentOptions.h"


NSString *const kPaymentRequestPaymentOptionsSaveCard = @"saveCard";
NSString *const kPaymentRequestPaymentOptionsCreditCard3dSecure = @"creditCard3dSecure";
NSString *const kPaymentRequestPaymentOptionsBank = @"bank";
NSString *const kPaymentRequestPaymentOptionsChannel = @"channel";
NSString *const kPaymentRequestPaymentOptionsBinpromo = @"binpromo";


@interface MTPaymentRequestPaymentOptions ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation MTPaymentRequestPaymentOptions

@synthesize saveCard = _saveCard;
@synthesize creditCard3dSecure = _creditCard3dSecure;
@synthesize bank = _bank;
@synthesize channel = _channel;
@synthesize binpromo = _binpromo;


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
            self.saveCard = [[self objectOrNilForKey:kPaymentRequestPaymentOptionsSaveCard fromDictionary:dict] boolValue];
            self.creditCard3dSecure = [[self objectOrNilForKey:kPaymentRequestPaymentOptionsCreditCard3dSecure fromDictionary:dict] boolValue];
            self.bank = [self objectOrNilForKey:kPaymentRequestPaymentOptionsBank fromDictionary:dict];
            self.channel = [self objectOrNilForKey:kPaymentRequestPaymentOptionsChannel fromDictionary:dict];
            self.binpromo = [self objectOrNilForKey:kPaymentRequestPaymentOptionsBinpromo fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithBool:self.saveCard] forKey:kPaymentRequestPaymentOptionsSaveCard];
    [mutableDict setValue:[NSNumber numberWithBool:self.creditCard3dSecure] forKey:kPaymentRequestPaymentOptionsCreditCard3dSecure];
    [mutableDict setValue:self.bank forKey:kPaymentRequestPaymentOptionsBank];
    [mutableDict setValue:self.channel forKey:kPaymentRequestPaymentOptionsChannel];
    NSMutableArray *tempArrayForBinpromo = [NSMutableArray array];
    for (NSObject *subArrayObject in self.binpromo) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForBinpromo addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForBinpromo addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForBinpromo] forKey:kPaymentRequestPaymentOptionsBinpromo];

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

    self.saveCard = [aDecoder decodeBoolForKey:kPaymentRequestPaymentOptionsSaveCard];
    self.creditCard3dSecure = [aDecoder decodeBoolForKey:kPaymentRequestPaymentOptionsCreditCard3dSecure];
    self.bank = [aDecoder decodeObjectForKey:kPaymentRequestPaymentOptionsBank];
    self.channel = [aDecoder decodeObjectForKey:kPaymentRequestPaymentOptionsChannel];
    self.binpromo = [aDecoder decodeObjectForKey:kPaymentRequestPaymentOptionsBinpromo];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeBool:_saveCard forKey:kPaymentRequestPaymentOptionsSaveCard];
    [aCoder encodeBool:_creditCard3dSecure forKey:kPaymentRequestPaymentOptionsCreditCard3dSecure];
    [aCoder encodeObject:_bank forKey:kPaymentRequestPaymentOptionsBank];
    [aCoder encodeObject:_channel forKey:kPaymentRequestPaymentOptionsChannel];
    [aCoder encodeObject:_binpromo forKey:kPaymentRequestPaymentOptionsBinpromo];
}

- (id)copyWithZone:(NSZone *)zone
{
    MTPaymentRequestPaymentOptions *copy = [[MTPaymentRequestPaymentOptions alloc] init];
    
    if (copy) {

        copy.saveCard = self.saveCard;
        copy.creditCard3dSecure = self.creditCard3dSecure;
        copy.bank = [self.bank copyWithZone:zone];
        copy.channel = [self.channel copyWithZone:zone];
        copy.binpromo = [self.binpromo copyWithZone:zone];
    }
    
    return copy;
}


@end
