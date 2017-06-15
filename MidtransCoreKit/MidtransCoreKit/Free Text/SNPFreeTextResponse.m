//
//  SNPFreeTextResponse.m
//
//  Created by Ratna Kumalasari on 5/25/17
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "SNPFreeTextResponse.h"
#import "SNPFreeTextFreeText.h"


NSString *const kSNPFreeTextResponseFreeText = @"free_text";


@interface SNPFreeTextResponse ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation SNPFreeTextResponse

@synthesize freeText = _freeText;


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
            self.freeText = [SNPFreeTextFreeText modelObjectWithDictionary:[dict objectForKey:kSNPFreeTextResponseFreeText]];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[self.freeText dictionaryRepresentation] forKey:kSNPFreeTextResponseFreeText];

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

    self.freeText = [aDecoder decodeObjectForKey:kSNPFreeTextResponseFreeText];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_freeText forKey:kSNPFreeTextResponseFreeText];
}

- (id)copyWithZone:(NSZone *)zone
{
    SNPFreeTextResponse *copy = [[SNPFreeTextResponse alloc] init];
    
    if (copy) {

        copy.freeText = [self.freeText copyWithZone:zone];
    }
    
    return copy;
}


@end
