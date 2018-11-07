//
//  SNPFreeTextInquiry.m
//
//  Created by Ratna Kumalasari on 5/25/17
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "SNPFreeTextInquiry.h"


NSString *const kSNPFreeTextInquiryId = @"id";
NSString *const kSNPFreeTextInquiryEn = @"en";


@interface SNPFreeTextInquiry ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation SNPFreeTextInquiry

@synthesize inquiryIdentifier = _inquiryIdentifier;
@synthesize en = _en;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.inquiryIdentifier = [self objectOrNilForKey:kSNPFreeTextInquiryId fromDictionary:dict];
            self.en = [self objectOrNilForKey:kSNPFreeTextInquiryEn fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.inquiryIdentifier forKey:kSNPFreeTextInquiryId];
    [mutableDict setValue:self.en forKey:kSNPFreeTextInquiryEn];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description  {
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    self.inquiryIdentifier = [aDecoder decodeObjectForKey:kSNPFreeTextInquiryId];
    self.en = [aDecoder decodeObjectForKey:kSNPFreeTextInquiryEn];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_inquiryIdentifier forKey:kSNPFreeTextInquiryId];
    [aCoder encodeObject:_en forKey:kSNPFreeTextInquiryEn];
}

- (id)copyWithZone:(NSZone *)zone
{
    SNPFreeTextInquiry *copy = [[SNPFreeTextInquiry alloc] init];
    
    if (copy) {

        copy.inquiryIdentifier = [self.inquiryIdentifier copyWithZone:zone];
        copy.en = [self.en copyWithZone:zone];
    }
    
    return copy;
}


@end
