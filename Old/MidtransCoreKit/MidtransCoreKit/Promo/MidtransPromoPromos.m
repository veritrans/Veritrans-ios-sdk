//
//  MidtransPromoPromos.m
//
//  Created by Ratna Kumalasari on 3/28/18
//  Copyright (c) 2018 __MyCompanyName__. All rights reserved.
//

#import "MidtransPromoPromos.h"


NSString *const kMidtransPromoPromosBins = @"bins";
NSString *const kMidtransPromoPromosDiscountType = @"discount_type";
NSString *const kMidtransPromoPromosId = @"id";
NSString *const kMidtransPromoPromosDiscountedGrossAmount = @"discounted_gross_amount";
NSString *const kMidtransPromoPromosCalculatedDiscountAmount = @"calculated_discount_amount";
NSString *const kMidtransPromoPromosPaymentTypes = @"payment_types";
NSString *const kMidtransPromoPromosName = @"name";


@interface MidtransPromoPromos ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation MidtransPromoPromos

@synthesize bins = _bins;
@synthesize discountType = _discountType;
@synthesize promosIdentifier = _promosIdentifier;
@synthesize discountedGrossAmount = _discountedGrossAmount;
@synthesize calculatedDiscountAmount = _calculatedDiscountAmount;
@synthesize paymentTypes = _paymentTypes;
@synthesize name = _name;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}
- (NSString *)removeAllWhitespace:(NSString *)string{
    return [string stringByReplacingOccurrencesOfString:@"\\s" withString:@""
                                              options:NSRegularExpressionSearch
                                                range:NSMakeRange(0, [string length])]
    ;
}
- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
        NSMutableArray *array = [NSMutableArray new];
        for (int i =0; i<[[self objectOrNilForKey:kMidtransPromoPromosBins fromDictionary:dict] count]; i++) {
            NSString *currValue  =[[[self objectOrNilForKey:kMidtransPromoPromosBins fromDictionary:dict] objectAtIndex:i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            [array addObject:currValue];
        }
            self.bins = array;
            self.discountType = [self objectOrNilForKey:kMidtransPromoPromosDiscountType fromDictionary:dict];
            self.promosIdentifier = [[self objectOrNilForKey:kMidtransPromoPromosId fromDictionary:dict] doubleValue];
            self.discountedGrossAmount = [[self objectOrNilForKey:kMidtransPromoPromosDiscountedGrossAmount fromDictionary:dict] doubleValue];
            self.calculatedDiscountAmount = [[self objectOrNilForKey:kMidtransPromoPromosCalculatedDiscountAmount fromDictionary:dict] doubleValue];
            self.paymentTypes = [self objectOrNilForKey:kMidtransPromoPromosPaymentTypes fromDictionary:dict];
            self.name = [self objectOrNilForKey:kMidtransPromoPromosName fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    NSMutableArray *tempArrayForBins = [NSMutableArray array];
    for (NSObject *subArrayObject in self.bins) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForBins addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForBins addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForBins] forKey:kMidtransPromoPromosBins];
    [mutableDict setValue:self.discountType forKey:kMidtransPromoPromosDiscountType];
    [mutableDict setValue:[NSNumber numberWithDouble:self.promosIdentifier] forKey:kMidtransPromoPromosId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.discountedGrossAmount] forKey:kMidtransPromoPromosDiscountedGrossAmount];
    [mutableDict setValue:[NSNumber numberWithDouble:self.calculatedDiscountAmount] forKey:kMidtransPromoPromosCalculatedDiscountAmount];
    NSMutableArray *tempArrayForPaymentTypes = [NSMutableArray array];
    for (NSObject *subArrayObject in self.paymentTypes) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForPaymentTypes addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForPaymentTypes addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForPaymentTypes] forKey:kMidtransPromoPromosPaymentTypes];
    [mutableDict setValue:self.name forKey:kMidtransPromoPromosName];

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

    self.bins = [aDecoder decodeObjectForKey:kMidtransPromoPromosBins];
    self.discountType = [aDecoder decodeObjectForKey:kMidtransPromoPromosDiscountType];
    self.promosIdentifier = [aDecoder decodeDoubleForKey:kMidtransPromoPromosId];
    self.discountedGrossAmount = [aDecoder decodeDoubleForKey:kMidtransPromoPromosDiscountedGrossAmount];
    self.calculatedDiscountAmount = [aDecoder decodeDoubleForKey:kMidtransPromoPromosCalculatedDiscountAmount];
    self.paymentTypes = [aDecoder decodeObjectForKey:kMidtransPromoPromosPaymentTypes];
    self.name = [aDecoder decodeObjectForKey:kMidtransPromoPromosName];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_bins forKey:kMidtransPromoPromosBins];
    [aCoder encodeObject:_discountType forKey:kMidtransPromoPromosDiscountType];
    [aCoder encodeDouble:_promosIdentifier forKey:kMidtransPromoPromosId];
    [aCoder encodeDouble:_discountedGrossAmount forKey:kMidtransPromoPromosDiscountedGrossAmount];
    [aCoder encodeDouble:_calculatedDiscountAmount forKey:kMidtransPromoPromosCalculatedDiscountAmount];
    [aCoder encodeObject:_paymentTypes forKey:kMidtransPromoPromosPaymentTypes];
    [aCoder encodeObject:_name forKey:kMidtransPromoPromosName];
}

- (id)copyWithZone:(NSZone *)zone
{
    MidtransPromoPromos *copy = [[MidtransPromoPromos alloc] init];
    
    if (copy) {

        copy.bins = [self.bins copyWithZone:zone];
        copy.discountType = [self.discountType copyWithZone:zone];
        copy.promosIdentifier = self.promosIdentifier;
        copy.discountedGrossAmount = self.discountedGrossAmount;
        copy.calculatedDiscountAmount = self.calculatedDiscountAmount;
        copy.paymentTypes = [self.paymentTypes copyWithZone:zone];
        copy.name = [self.name copyWithZone:zone];
    }
    
    return copy;
}


@end
