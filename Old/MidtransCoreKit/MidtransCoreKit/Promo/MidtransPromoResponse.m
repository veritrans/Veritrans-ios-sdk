//
//  MidtransPromoResponse.m
//
//  Created by Ratna Kumalasari on 3/28/18
//  Copyright (c) 2018 __MyCompanyName__. All rights reserved.
//

#import "MidtransPromoResponse.h"
#import "MidtransPromoPromoDetails.h"


NSString *const kMidtransPromoResponsePromoDetails = @"promo_details";


@interface MidtransPromoResponse ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation MidtransPromoResponse

@synthesize promoDetails = _promoDetails;


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
            self.promoDetails = [MidtransPromoPromoDetails modelObjectWithDictionary:[dict objectForKey:kMidtransPromoResponsePromoDetails]];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[self.promoDetails dictionaryRepresentation] forKey:kMidtransPromoResponsePromoDetails];

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

    self.promoDetails = [aDecoder decodeObjectForKey:kMidtransPromoResponsePromoDetails];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_promoDetails forKey:kMidtransPromoResponsePromoDetails];
}

- (id)copyWithZone:(NSZone *)zone
{
    MidtransPromoResponse *copy = [[MidtransPromoResponse alloc] init];
    
    if (copy) {

        copy.promoDetails = [self.promoDetails copyWithZone:zone];
    }
    
    return copy;
}


@end
