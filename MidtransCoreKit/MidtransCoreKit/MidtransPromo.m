//
//  MidtransPromo.m
//
//  Created by Nanang  on 2/6/17
//  Copyright (c) 2017 Zahir. All rights reserved.
//

#import "MidtransPromo.h"


NSString *const kMidtransPromoSponsorMessageEn = @"sponsor_message_en";
NSString *const kMidtransPromoPromoCode = @"promo_code";
NSString *const kMidtransPromoDiscountType = @"discount_type";
NSString *const kMidtransPromoId = @"id";
NSString *const kMidtransPromoSponsorName = @"sponsor_name";
NSString *const kMidtransPromoBins = @"bins";
NSString *const kMidtransPromoStartDate = @"start_date";
NSString *const kMidtransPromoSponsorMessageId = @"sponsor_message_id";
NSString *const kMidtransPromoDiscountAmount = @"discount_amount";
NSString *const kMidtransPromoEndDate = @"end_date";


@interface MidtransPromo ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation MidtransPromo

@synthesize sponsorMessageEn = _sponsorMessageEn;
@synthesize promoCode = _promoCode;
@synthesize discountType = _discountType;
@synthesize promoIdentifier = _promoIdentifier;
@synthesize sponsorName = _sponsorName;
@synthesize bins = _bins;
@synthesize startDate = _startDate;
@synthesize sponsorMessageId = _sponsorMessageId;
@synthesize discountAmount = _discountAmount;
@synthesize endDate = _endDate;


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
            self.sponsorMessageEn = [self objectOrNilForKey:kMidtransPromoSponsorMessageEn fromDictionary:dict];
            self.promoCode = [self objectOrNilForKey:kMidtransPromoPromoCode fromDictionary:dict];
            self.discountType = [self objectOrNilForKey:kMidtransPromoDiscountType fromDictionary:dict];
            self.promoIdentifier = [[self objectOrNilForKey:kMidtransPromoId fromDictionary:dict] doubleValue];
            self.sponsorName = [self objectOrNilForKey:kMidtransPromoSponsorName fromDictionary:dict];
            self.bins = [self objectOrNilForKey:kMidtransPromoBins fromDictionary:dict];
            self.startDate = [self objectOrNilForKey:kMidtransPromoStartDate fromDictionary:dict];
            self.sponsorMessageId = [self objectOrNilForKey:kMidtransPromoSponsorMessageId fromDictionary:dict];
            self.discountAmount = [[self objectOrNilForKey:kMidtransPromoDiscountAmount fromDictionary:dict] doubleValue];
            self.endDate = [self objectOrNilForKey:kMidtransPromoEndDate fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.sponsorMessageEn forKey:kMidtransPromoSponsorMessageEn];
    [mutableDict setValue:self.promoCode forKey:kMidtransPromoPromoCode];
    [mutableDict setValue:self.discountType forKey:kMidtransPromoDiscountType];
    [mutableDict setValue:[NSNumber numberWithDouble:self.promoIdentifier] forKey:kMidtransPromoId];
    [mutableDict setValue:self.sponsorName forKey:kMidtransPromoSponsorName];
    NSMutableArray *tempArrayForBins = [NSMutableArray array];
    for (NSObject *subArrayObject in self.bins) {
        if ([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForBins addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForBins addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForBins] forKey:kMidtransPromoBins];
    [mutableDict setValue:self.startDate forKey:kMidtransPromoStartDate];
    [mutableDict setValue:self.sponsorMessageId forKey:kMidtransPromoSponsorMessageId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.discountAmount] forKey:kMidtransPromoDiscountAmount];
    [mutableDict setValue:self.endDate forKey:kMidtransPromoEndDate];

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

    self.sponsorMessageEn = [aDecoder decodeObjectForKey:kMidtransPromoSponsorMessageEn];
    self.promoCode = [aDecoder decodeObjectForKey:kMidtransPromoPromoCode];
    self.discountType = [aDecoder decodeObjectForKey:kMidtransPromoDiscountType];
    self.promoIdentifier = [aDecoder decodeDoubleForKey:kMidtransPromoId];
    self.sponsorName = [aDecoder decodeObjectForKey:kMidtransPromoSponsorName];
    self.bins = [aDecoder decodeObjectForKey:kMidtransPromoBins];
    self.startDate = [aDecoder decodeObjectForKey:kMidtransPromoStartDate];
    self.sponsorMessageId = [aDecoder decodeObjectForKey:kMidtransPromoSponsorMessageId];
    self.discountAmount = [aDecoder decodeDoubleForKey:kMidtransPromoDiscountAmount];
    self.endDate = [aDecoder decodeObjectForKey:kMidtransPromoEndDate];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_sponsorMessageEn forKey:kMidtransPromoSponsorMessageEn];
    [aCoder encodeObject:_promoCode forKey:kMidtransPromoPromoCode];
    [aCoder encodeObject:_discountType forKey:kMidtransPromoDiscountType];
    [aCoder encodeDouble:_promoIdentifier forKey:kMidtransPromoId];
    [aCoder encodeObject:_sponsorName forKey:kMidtransPromoSponsorName];
    [aCoder encodeObject:_bins forKey:kMidtransPromoBins];
    [aCoder encodeObject:_startDate forKey:kMidtransPromoStartDate];
    [aCoder encodeObject:_sponsorMessageId forKey:kMidtransPromoSponsorMessageId];
    [aCoder encodeDouble:_discountAmount forKey:kMidtransPromoDiscountAmount];
    [aCoder encodeObject:_endDate forKey:kMidtransPromoEndDate];
}

- (id)copyWithZone:(NSZone *)zone
{
    MidtransPromo *copy = [[MidtransPromo alloc] init];
    
    if (copy) {

        copy.sponsorMessageEn = [self.sponsorMessageEn copyWithZone:zone];
        copy.promoCode = [self.promoCode copyWithZone:zone];
        copy.discountType = [self.discountType copyWithZone:zone];
        copy.promoIdentifier = self.promoIdentifier;
        copy.sponsorName = [self.sponsorName copyWithZone:zone];
        copy.bins = [self.bins copyWithZone:zone];
        copy.startDate = [self.startDate copyWithZone:zone];
        copy.sponsorMessageId = [self.sponsorMessageId copyWithZone:zone];
        copy.discountAmount = self.discountAmount;
        copy.endDate = [self.endDate copyWithZone:zone];
    }
    
    return copy;
}


@end
