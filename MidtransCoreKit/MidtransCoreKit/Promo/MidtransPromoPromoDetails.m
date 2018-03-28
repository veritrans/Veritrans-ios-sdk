//
//  MidtransPromoPromoDetails.m
//
//  Created by Ratna Kumalasari on 3/28/18
//  Copyright (c) 2018 __MyCompanyName__. All rights reserved.
//

#import "MidtransPromoPromoDetails.h"
#import "MidtransPromoPromos.h"


NSString *const kMidtransPromoPromoDetailsPromos = @"promos";


@interface MidtransPromoPromoDetails ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation MidtransPromoPromoDetails

@synthesize promos = _promos;


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
    NSObject *receivedMidtransPromoPromos = [dict objectForKey:kMidtransPromoPromoDetailsPromos];
    NSMutableArray *parsedMidtransPromoPromos = [NSMutableArray array];
    if ([receivedMidtransPromoPromos isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedMidtransPromoPromos) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedMidtransPromoPromos addObject:[MidtransPromoPromos modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedMidtransPromoPromos isKindOfClass:[NSDictionary class]]) {
       [parsedMidtransPromoPromos addObject:[MidtransPromoPromos modelObjectWithDictionary:(NSDictionary *)receivedMidtransPromoPromos]];
    }

    self.promos = [NSArray arrayWithArray:parsedMidtransPromoPromos];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    NSMutableArray *tempArrayForPromos = [NSMutableArray array];
    for (NSObject *subArrayObject in self.promos) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForPromos addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForPromos addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForPromos] forKey:kMidtransPromoPromoDetailsPromos];

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

    self.promos = [aDecoder decodeObjectForKey:kMidtransPromoPromoDetailsPromos];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_promos forKey:kMidtransPromoPromoDetailsPromos];
}

- (id)copyWithZone:(NSZone *)zone
{
    MidtransPromoPromoDetails *copy = [[MidtransPromoPromoDetails alloc] init];
    
    if (copy) {

        copy.promos = [self.promos copyWithZone:zone];
    }
    
    return copy;
}


@end
