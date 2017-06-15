//
//  MidtransBinResponse.m
//
//  Created by Zanna Simarmata on 12/22/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "MidtransBinResponse.h"
#import "MidtransHelper.h"
NSString *const kMidtransBinResponseBins = @"bins";
NSString *const kMidtransBinResponseBank = @"bank";


@interface MidtransBinResponse ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation MidtransBinResponse

@synthesize bins = _bins;
@synthesize bank = _bank;

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
            self.bins = [self objectOrNilForKey:kMidtransBinResponseBins fromDictionary:dict];
            self.bank = [self objectOrNilForKey:kMidtransBinResponseBank fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
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
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForBins] forKey:kMidtransBinResponseBins];
    [mutableDict setValue:self.bank forKey:kMidtransBinResponseBank];

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

    self.bins = [aDecoder decodeObjectForKey:kMidtransBinResponseBins];
    self.bank = [aDecoder decodeObjectForKey:kMidtransBinResponseBank];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_bins forKey:kMidtransBinResponseBins];
    [aCoder encodeObject:_bank forKey:kMidtransBinResponseBank];
}

- (id)copyWithZone:(NSZone *)zone
{
    MidtransBinResponse *copy = [[MidtransBinResponse alloc] init];
    
    if (copy) {

        copy.bins = [self.bins copyWithZone:zone];
        copy.bank = [self.bank copyWithZone:zone];
    }
    
    return copy;
}


@end
