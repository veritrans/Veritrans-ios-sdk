//
//  MidtransPaymentRequestV2Terms.m
//
//  Created by Zanna Simarmata on 1/3/17
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "MidtransPaymentRequestV2Terms.h"


NSString *const kMidtransPaymentRequestV2TermsMandiri = @"mandiri";
NSString *const kMidtransPaymentRequestV2TermsBni = @"bni";
NSString *const kMidtransPaymentRequestV2TermsBca = @"bca";
NSString *const kMidtransPaymentRequestV2TermsOffline = @"offline";


@interface MidtransPaymentRequestV2Terms ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation MidtransPaymentRequestV2Terms

@synthesize mandiri = _mandiri;
@synthesize bni = _bni;
@synthesize bca = _bca;
@synthesize offline = _offline;


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
            self.mandiri = [self objectOrNilForKey:kMidtransPaymentRequestV2TermsMandiri fromDictionary:dict];
            self.bni = [self objectOrNilForKey:kMidtransPaymentRequestV2TermsBni fromDictionary:dict];
            self.bca = [self objectOrNilForKey:kMidtransPaymentRequestV2TermsBca fromDictionary:dict];
            self.offline = [self objectOrNilForKey:kMidtransPaymentRequestV2TermsOffline fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    NSMutableArray *tempArrayForMandiri = [NSMutableArray array];
    for (NSObject *subArrayObject in self.mandiri) {
        if ([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForMandiri addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForMandiri addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForMandiri] forKey:kMidtransPaymentRequestV2TermsMandiri];
    NSMutableArray *tempArrayForBni = [NSMutableArray array];
    for (NSObject *subArrayObject in self.bni) {
        if ([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForBni addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForBni addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForBni] forKey:kMidtransPaymentRequestV2TermsBni];
    NSMutableArray *tempArrayForBca = [NSMutableArray array];
    for (NSObject *subArrayObject in self.bca) {
        if ([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForBca addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForBca addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForBca] forKey:kMidtransPaymentRequestV2TermsBca];
    NSMutableArray *tempArrayForOffline = [NSMutableArray array];
    for (NSObject *subArrayObject in self.offline) {
        if ([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForOffline addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForOffline addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForOffline] forKey:kMidtransPaymentRequestV2TermsOffline];

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

    self.mandiri = [aDecoder decodeObjectForKey:kMidtransPaymentRequestV2TermsMandiri];
    self.bni = [aDecoder decodeObjectForKey:kMidtransPaymentRequestV2TermsBni];
    self.bca = [aDecoder decodeObjectForKey:kMidtransPaymentRequestV2TermsBca];
    self.offline = [aDecoder decodeObjectForKey:kMidtransPaymentRequestV2TermsOffline];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_mandiri forKey:kMidtransPaymentRequestV2TermsMandiri];
    [aCoder encodeObject:_bni forKey:kMidtransPaymentRequestV2TermsBni];
    [aCoder encodeObject:_bca forKey:kMidtransPaymentRequestV2TermsBca];
    [aCoder encodeObject:_offline forKey:kMidtransPaymentRequestV2TermsOffline];
}

- (id)copyWithZone:(NSZone *)zone
{
    MidtransPaymentRequestV2Terms *copy = [[MidtransPaymentRequestV2Terms alloc] init];
    
    if (copy) {

        copy.mandiri = [self.mandiri copyWithZone:zone];
        copy.bni = [self.bni copyWithZone:zone];
        copy.bca = [self.bca copyWithZone:zone];
        copy.offline = [self.offline copyWithZone:zone];
    }
    
    return copy;
}


@end
