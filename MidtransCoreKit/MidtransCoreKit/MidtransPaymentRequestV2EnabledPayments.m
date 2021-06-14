//
//  MidtransPaymentRequestV2EnabledPayments.m
//
//  Created by Ratna Kumalasari on 10/25/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "MidtransPaymentRequestV2EnabledPayments.h"


NSString *const kMidtransPaymentRequestV2EnabledPaymentsType = @"type";
NSString *const kMidtransPaymentRequestV2EnabledPaymentsCategory = @"category";
NSString *const kMidtransPaymentRequestV2EnabledPaymentsStatus = @"status";
NSString *const kMidtransPaymentRequestV2EnabledPaymentsAcquirer = @"acquirer";
NSString *const kMidtransPaymentRequestV2EnabledPaymentsMode = @"mode";


@interface MidtransPaymentRequestV2EnabledPayments ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation MidtransPaymentRequestV2EnabledPayments

@synthesize type = _type;
@synthesize category = _category;
@synthesize status = _status;

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
        self.type = [self objectOrNilForKey:kMidtransPaymentRequestV2EnabledPaymentsType fromDictionary:dict];
        self.status =  [self objectOrNilForKey:kMidtransPaymentRequestV2EnabledPaymentsStatus fromDictionary:dict];
        self.category = [self objectOrNilForKey:kMidtransPaymentRequestV2EnabledPaymentsCategory fromDictionary:dict];
        self.acquirer = [self objectOrNilForKey:kMidtransPaymentRequestV2EnabledPaymentsAcquirer fromDictionary:dict];
        self.mode = [self objectOrNilForKey:kMidtransPaymentRequestV2EnabledPaymentsMode fromDictionary:dict];
    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    NSMutableArray *tempArrayForMode = [NSMutableArray array];
    for (NSObject *subArrayObject in self.mode) {
        if ([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForMode addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForMode addObject:subArrayObject];
        }
    }
    [mutableDict setValue:self.type forKey:kMidtransPaymentRequestV2EnabledPaymentsType];
    [mutableDict setValue:self.status forKey:kMidtransPaymentRequestV2EnabledPaymentsStatus];
    [mutableDict setValue:self.category forKey:kMidtransPaymentRequestV2EnabledPaymentsCategory];
    [mutableDict setValue:self.acquirer forKey:kMidtransPaymentRequestV2EnabledPaymentsAcquirer];
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForMode] forKey:kMidtransPaymentRequestV2EnabledPaymentsMode];
    
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
    
    self.type = [aDecoder decodeObjectForKey:kMidtransPaymentRequestV2EnabledPaymentsType];
    self.status = [aDecoder decodeObjectForKey:kMidtransPaymentRequestV2EnabledPaymentsStatus];
    self.category = [aDecoder decodeObjectForKey:kMidtransPaymentRequestV2EnabledPaymentsCategory];
    self.acquirer = [aDecoder decodeObjectForKey:kMidtransPaymentRequestV2EnabledPaymentsAcquirer];
    self.mode = [aDecoder decodeObjectForKey:kMidtransPaymentRequestV2EnabledPaymentsMode];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_status forKey:kMidtransPaymentRequestV2EnabledPaymentsStatus];
    [aCoder encodeObject:_type forKey:kMidtransPaymentRequestV2EnabledPaymentsType];
    [aCoder encodeObject:_category forKey:kMidtransPaymentRequestV2EnabledPaymentsCategory];
    [aCoder encodeObject:_acquirer forKey:kMidtransPaymentRequestV2EnabledPaymentsAcquirer];
    [aCoder encodeObject:_mode forKey:kMidtransPaymentRequestV2EnabledPaymentsMode];
}

- (id)copyWithZone:(NSZone *)zone
{
    MidtransPaymentRequestV2EnabledPayments *copy = [[MidtransPaymentRequestV2EnabledPayments alloc] init];
    
    if (copy) {
        
        copy.type = [self.type copyWithZone:zone];
        copy.status = [self.status copyWithZone:zone];
        copy.category = [self.category copyWithZone:zone];
        copy.acquirer = [self.acquirer copyWithZone:zone];
        copy.mode = [self.mode copyWithZone:zone];
    }
    
    return copy;
}


@end
