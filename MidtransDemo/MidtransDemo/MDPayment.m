//
//  MDPayment.m
//
//  Created by Nanang  on 5/8/17
//  Copyright (c) 2017 Zahir. All rights reserved.
//

#import "MDPayment.h"


NSString *const kMDPaymentType = @"type";
NSString *const kMDPaymentName = @"name";


@interface MDPayment ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation MDPayment

@synthesize type = _type;
@synthesize name = _name;


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
            self.type = [self objectOrNilForKey:kMDPaymentType fromDictionary:dict];
            self.name = [self objectOrNilForKey:kMDPaymentName fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.type forKey:kMDPaymentType];
    [mutableDict setValue:self.name forKey:kMDPaymentName];

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

    self.type = [aDecoder decodeObjectForKey:kMDPaymentType];
    self.name = [aDecoder decodeObjectForKey:kMDPaymentName];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_type forKey:kMDPaymentType];
    [aCoder encodeObject:_name forKey:kMDPaymentName];
}

- (id)copyWithZone:(NSZone *)zone
{
    MDPayment *copy = [[MDPayment alloc] init];
    
    if (copy) {

        copy.type = [self.type copyWithZone:zone];
        copy.name = [self.name copyWithZone:zone];
    }
    
    return copy;
}


@end
