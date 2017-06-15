//
//  VirtualAccountModel.m
//
//  Created by Arie  on 6/21/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "MidtransVirtualAccountModel.h"


NSString *const kVirtualAccountModelName = @"name";
NSString *const kVirtualAccountModelGuides = @"guides";


@interface MidtransVirtualAccountModel ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation MidtransVirtualAccountModel

@synthesize name = _name;
@synthesize guides = _guides;


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
        self.name = [self objectOrNilForKey:kVirtualAccountModelName fromDictionary:dict];
        self.guides = [self objectOrNilForKey:kVirtualAccountModelGuides fromDictionary:dict];
        
    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.name forKey:kVirtualAccountModelName];
    NSMutableArray *tempArrayForGuides = [NSMutableArray array];
    for (NSObject *subArrayObject in self.guides) {
        if ([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForGuides addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForGuides addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForGuides] forKey:kVirtualAccountModelGuides];
    
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
    
    self.name = [aDecoder decodeObjectForKey:kVirtualAccountModelName];
    self.guides = [aDecoder decodeObjectForKey:kVirtualAccountModelGuides];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
    [aCoder encodeObject:_name forKey:kVirtualAccountModelName];
    [aCoder encodeObject:_guides forKey:kVirtualAccountModelGuides];
}

- (id)copyWithZone:(NSZone *)zone
{
    MidtransVirtualAccountModel *copy = [[MidtransVirtualAccountModel alloc] init];
    
    if (copy) {
        
        copy.name = [self.name copyWithZone:zone];
        copy.guides = [self.guides copyWithZone:zone];
    }
    
    return copy;
}


@end
