//
//  MIDBinResponse.m
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 04/03/19.
//  Copyright © 2019 Midtrans. All rights reserved.
//

#import "MIDBinResponse.h"

NSString *const kMIDBinResponseBins = @"bins";
NSString *const kMIDBinResponseBank = @"bank";


@interface MIDBinResponse ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation MIDBinResponse

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
        self.bins = [self objectOrNilForKey:kMIDBinResponseBins fromDictionary:dict];
        self.bank = [self objectOrNilForKey:kMIDBinResponseBank fromDictionary:dict];
        
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
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForBins] forKey:kMIDBinResponseBins];
    [mutableDict setValue:self.bank forKey:kMIDBinResponseBank];
    
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
    
    self.bins = [aDecoder decodeObjectForKey:kMIDBinResponseBins];
    self.bank = [aDecoder decodeObjectForKey:kMIDBinResponseBank];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
    [aCoder encodeObject:_bins forKey:kMIDBinResponseBins];
    [aCoder encodeObject:_bank forKey:kMIDBinResponseBank];
}

- (id)copyWithZone:(NSZone *)zone
{
    MIDBinResponse *copy = [[MIDBinResponse alloc] init];
    
    if (copy) {
        
        copy.bins = [self.bins copyWithZone:zone];
        copy.bank = [self.bank copyWithZone:zone];
    }
    
    return copy;
}


@end
