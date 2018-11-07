//
//  MidtransObtainedPromo.m
//
//  Created by Nanang  on 2/6/17
//  Copyright (c) 2017 Zahir. All rights reserved.
//

#import "MidtransObtainedPromo.h"


NSString *const kMidtransObtainedPromoSponsorMessageEn = @"sponsor_message_en";
NSString *const kMidtransObtainedPromoPromoCode = @"promo_code";
NSString *const kMidtransObtainedPromoDiscountToken = @"discount_token";
NSString *const kMidtransObtainedPromoSponsorName = @"sponsor_name";
NSString *const kMidtransObtainedPromoExpiresAt = @"expires_at";
NSString *const kMidtransObtainedPromoSuccess = @"success";
NSString *const kMidtransObtainedPromoMessage = @"message";
NSString *const kMidtransObtainedPromoSponsorMessageId = @"sponsor_message_id";
NSString *const kMidtransObtainedPromoPaymentAmount = @"payment_amount";
NSString *const kMidtransObtainedPromoDiscountAmount = @"discount_amount";


@interface MidtransObtainedPromo ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation MidtransObtainedPromo

@synthesize sponsorMessageEn = _sponsorMessageEn;
@synthesize promoCode = _promoCode;
@synthesize discountToken = _discountToken;
@synthesize sponsorName = _sponsorName;
@synthesize expiresAt = _expiresAt;
@synthesize success = _success;
@synthesize message = _message;
@synthesize sponsorMessageId = _sponsorMessageId;
@synthesize paymentAmount = _paymentAmount;
@synthesize discountAmount = _discountAmount;


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
        self.sponsorMessageEn = [self objectOrNilForKey:kMidtransObtainedPromoSponsorMessageEn fromDictionary:dict];
        self.promoCode = [self objectOrNilForKey:kMidtransObtainedPromoPromoCode fromDictionary:dict];
        self.discountToken = [self objectOrNilForKey:kMidtransObtainedPromoDiscountToken fromDictionary:dict];
        self.sponsorName = [self objectOrNilForKey:kMidtransObtainedPromoSponsorName fromDictionary:dict];
        self.expiresAt = [self objectOrNilForKey:kMidtransObtainedPromoExpiresAt fromDictionary:dict];
        self.success = [[self objectOrNilForKey:kMidtransObtainedPromoSuccess fromDictionary:dict] boolValue];
        self.message = [self objectOrNilForKey:kMidtransObtainedPromoMessage fromDictionary:dict];
        self.sponsorMessageId = [self objectOrNilForKey:kMidtransObtainedPromoSponsorMessageId fromDictionary:dict];
        self.paymentAmount = [[self objectOrNilForKey:kMidtransObtainedPromoPaymentAmount fromDictionary:dict] doubleValue];
        self.discountAmount = [[self objectOrNilForKey:kMidtransObtainedPromoDiscountAmount fromDictionary:dict] doubleValue];
        
    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.sponsorMessageEn forKey:kMidtransObtainedPromoSponsorMessageEn];
    [mutableDict setValue:self.promoCode forKey:kMidtransObtainedPromoPromoCode];
    [mutableDict setValue:self.discountToken forKey:kMidtransObtainedPromoDiscountToken];
    [mutableDict setValue:self.sponsorName forKey:kMidtransObtainedPromoSponsorName];
    [mutableDict setValue:self.expiresAt forKey:kMidtransObtainedPromoExpiresAt];
    [mutableDict setValue:[NSNumber numberWithBool:self.success] forKey:kMidtransObtainedPromoSuccess];
    [mutableDict setValue:self.message forKey:kMidtransObtainedPromoMessage];
    [mutableDict setValue:self.sponsorMessageId forKey:kMidtransObtainedPromoSponsorMessageId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.paymentAmount] forKey:kMidtransObtainedPromoPaymentAmount];
    [mutableDict setValue:[NSNumber numberWithDouble:self.discountAmount] forKey:kMidtransObtainedPromoDiscountAmount];
    
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
    
    self.sponsorMessageEn = [aDecoder decodeObjectForKey:kMidtransObtainedPromoSponsorMessageEn];
    self.promoCode = [aDecoder decodeObjectForKey:kMidtransObtainedPromoPromoCode];
    self.discountToken = [aDecoder decodeObjectForKey:kMidtransObtainedPromoDiscountToken];
    self.sponsorName = [aDecoder decodeObjectForKey:kMidtransObtainedPromoSponsorName];
    self.expiresAt = [aDecoder decodeObjectForKey:kMidtransObtainedPromoExpiresAt];
    self.success = [aDecoder decodeBoolForKey:kMidtransObtainedPromoSuccess];
    self.message = [aDecoder decodeObjectForKey:kMidtransObtainedPromoMessage];
    self.sponsorMessageId = [aDecoder decodeObjectForKey:kMidtransObtainedPromoSponsorMessageId];
    self.paymentAmount = [aDecoder decodeDoubleForKey:kMidtransObtainedPromoPaymentAmount];
    self.discountAmount = [aDecoder decodeDoubleForKey:kMidtransObtainedPromoDiscountAmount];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
    [aCoder encodeObject:_sponsorMessageEn forKey:kMidtransObtainedPromoSponsorMessageEn];
    [aCoder encodeObject:_promoCode forKey:kMidtransObtainedPromoPromoCode];
    [aCoder encodeObject:_discountToken forKey:kMidtransObtainedPromoDiscountToken];
    [aCoder encodeObject:_sponsorName forKey:kMidtransObtainedPromoSponsorName];
    [aCoder encodeObject:_expiresAt forKey:kMidtransObtainedPromoExpiresAt];
    [aCoder encodeBool:_success forKey:kMidtransObtainedPromoSuccess];
    [aCoder encodeObject:_message forKey:kMidtransObtainedPromoMessage];
    [aCoder encodeObject:_sponsorMessageId forKey:kMidtransObtainedPromoSponsorMessageId];
    [aCoder encodeDouble:_paymentAmount forKey:kMidtransObtainedPromoPaymentAmount];
    [aCoder encodeDouble:_discountAmount forKey:kMidtransObtainedPromoDiscountAmount];
}

- (id)copyWithZone:(NSZone *)zone
{
    MidtransObtainedPromo *copy = [[MidtransObtainedPromo alloc] init];
    
    if (copy) {
        
        copy.sponsorMessageEn = [self.sponsorMessageEn copyWithZone:zone];
        copy.promoCode = [self.promoCode copyWithZone:zone];
        copy.discountToken = [self.discountToken copyWithZone:zone];
        copy.sponsorName = [self.sponsorName copyWithZone:zone];
        copy.expiresAt = [self.expiresAt copyWithZone:zone];
        copy.success = self.success;
        copy.message = [self.message copyWithZone:zone];
        copy.sponsorMessageId = [self.sponsorMessageId copyWithZone:zone];
        copy.paymentAmount = self.paymentAmount;
        copy.discountAmount = self.discountAmount;
    }
    
    return copy;
}


@end
