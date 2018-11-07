//
//  SNPFreeTextFreeText.m
//
//  Created by Ratna Kumalasari on 5/25/17
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "SNPFreeTextFreeText.h"
#import "SNPFreeTextInquiry.h"
#import "SNPFreeTextPayment.h"


NSString *const kSNPFreeTextFreeTextInquiry = @"inquiry";
NSString *const kSNPFreeTextFreeTextPayment = @"payment";


@interface SNPFreeTextFreeText ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation SNPFreeTextFreeText

@synthesize inquiry = _inquiry;
@synthesize payment = _payment;


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
    NSObject *receivedSNPFreeTextInquiry = [dict objectForKey:kSNPFreeTextFreeTextInquiry];
    NSMutableArray *parsedSNPFreeTextInquiry = [NSMutableArray array];
    if ([receivedSNPFreeTextInquiry isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedSNPFreeTextInquiry) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedSNPFreeTextInquiry addObject:[SNPFreeTextInquiry modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedSNPFreeTextInquiry isKindOfClass:[NSDictionary class]]) {
       [parsedSNPFreeTextInquiry addObject:[SNPFreeTextInquiry modelObjectWithDictionary:(NSDictionary *)receivedSNPFreeTextInquiry]];
    }

    self.inquiry = [NSArray arrayWithArray:parsedSNPFreeTextInquiry];
    NSObject *receivedSNPFreeTextPayment = [dict objectForKey:kSNPFreeTextFreeTextPayment];
    NSMutableArray *parsedSNPFreeTextPayment = [NSMutableArray array];
    if ([receivedSNPFreeTextPayment isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedSNPFreeTextPayment) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedSNPFreeTextPayment addObject:[SNPFreeTextPayment modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedSNPFreeTextPayment isKindOfClass:[NSDictionary class]]) {
       [parsedSNPFreeTextPayment addObject:[SNPFreeTextPayment modelObjectWithDictionary:(NSDictionary *)receivedSNPFreeTextPayment]];
    }

    self.payment = [NSArray arrayWithArray:parsedSNPFreeTextPayment];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    NSMutableArray *tempArrayForInquiry = [NSMutableArray array];
    for (NSObject *subArrayObject in self.inquiry) {
        if ([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForInquiry addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForInquiry addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForInquiry] forKey:kSNPFreeTextFreeTextInquiry];
    NSMutableArray *tempArrayForPayment = [NSMutableArray array];
    for (NSObject *subArrayObject in self.payment) {
        if ([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForPayment addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForPayment addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForPayment] forKey:kSNPFreeTextFreeTextPayment];

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

    self.inquiry = [aDecoder decodeObjectForKey:kSNPFreeTextFreeTextInquiry];
    self.payment = [aDecoder decodeObjectForKey:kSNPFreeTextFreeTextPayment];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_inquiry forKey:kSNPFreeTextFreeTextInquiry];
    [aCoder encodeObject:_payment forKey:kSNPFreeTextFreeTextPayment];
}

- (id)copyWithZone:(NSZone *)zone
{
    SNPFreeTextFreeText *copy = [[SNPFreeTextFreeText alloc] init];
    
    if (copy) {

        copy.inquiry = [self.inquiry copyWithZone:zone];
        copy.payment = [self.payment copyWithZone:zone];
    }
    
    return copy;
}


@end
