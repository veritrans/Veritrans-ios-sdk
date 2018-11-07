//
//  AddOnConstructor.m
//
//  Created by Zanna Simarmata on 1/24/17
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "AddOnConstructor.h"


NSString *const kAddOnConstructorAddOnTitle = @"addOnTitle";
NSString *const kAddOnConstructorAddOnDescriptions = @"addOnDescriptions";
NSString *const kAddOnConstructorAddOnName = @"addOnName";
NSString *const kAddOnConstructorAddOnAddtional = @"addOnAdditional";


@interface AddOnConstructor ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation AddOnConstructor

@synthesize addOnTitle = _addOnTitle;
@synthesize addOnDescriptions = _addOnDescriptions;
@synthesize addOnName = _addOnName;
@synthesize addOnAddtional = _addOnAddtional;


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
            self.addOnTitle = [self objectOrNilForKey:kAddOnConstructorAddOnTitle fromDictionary:dict];
            self.addOnDescriptions = [self objectOrNilForKey:kAddOnConstructorAddOnDescriptions fromDictionary:dict];
            self.addOnName = [self objectOrNilForKey:kAddOnConstructorAddOnName fromDictionary:dict];
         self.addOnAddtional = [self objectOrNilForKey:kAddOnConstructorAddOnAddtional fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.addOnTitle forKey:kAddOnConstructorAddOnTitle];
    [mutableDict setValue:self.addOnDescriptions forKey:kAddOnConstructorAddOnDescriptions];
    [mutableDict setValue:self.addOnName forKey:kAddOnConstructorAddOnName];
    
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

    self.addOnTitle = [aDecoder decodeObjectForKey:kAddOnConstructorAddOnTitle];
    self.addOnDescriptions = [aDecoder decodeObjectForKey:kAddOnConstructorAddOnDescriptions];
    self.addOnName = [aDecoder decodeObjectForKey:kAddOnConstructorAddOnName];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_addOnTitle forKey:kAddOnConstructorAddOnTitle];
    [aCoder encodeObject:_addOnDescriptions forKey:kAddOnConstructorAddOnDescriptions];
    [aCoder encodeObject:_addOnName forKey:kAddOnConstructorAddOnName];
}

- (id)copyWithZone:(NSZone *)zone
{
    AddOnConstructor *copy = [[AddOnConstructor alloc] init];
    
    if (copy) {

        copy.addOnTitle = [self.addOnTitle copyWithZone:zone];
        copy.addOnDescriptions = [self.addOnDescriptions copyWithZone:zone];
        copy.addOnName = [self.addOnName copyWithZone:zone];
    }
    
    return copy;
}


@end
