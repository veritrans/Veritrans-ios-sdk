//
//  MidtransPaymentRequestV2TransactionDetails.m
//
//  Created by Ratna Kumalasari on 10/25/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "MidtransPaymentRequestV2TransactionDetails.h"

NSString *const kMidtransPaymentRequestV2TransactionDetailsOrderId = @"order_id";
NSString *const kMidtransPaymentRequestV2TransactionDetailsGrossAmount = @"gross_amount";

@interface MidtransPaymentRequestV2TransactionDetails ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation MidtransPaymentRequestV2TransactionDetails

@synthesize orderId = _orderId;
@synthesize grossAmount = _grossAmount;


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
        self.orderId = [self objectOrNilForKey:kMidtransPaymentRequestV2TransactionDetailsOrderId fromDictionary:dict];
        self.grossAmount = [self objectOrNilForKey:kMidtransPaymentRequestV2TransactionDetailsGrossAmount fromDictionary:dict];
        
    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.orderId forKey:kMidtransPaymentRequestV2TransactionDetailsOrderId];
    [mutableDict setValue:self.grossAmount forKey:kMidtransPaymentRequestV2TransactionDetailsGrossAmount];
    
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

    self.orderId = [aDecoder decodeObjectForKey:kMidtransPaymentRequestV2TransactionDetailsOrderId];
    self.grossAmount = [aDecoder decodeObjectForKey:kMidtransPaymentRequestV2TransactionDetailsGrossAmount];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_orderId forKey:kMidtransPaymentRequestV2TransactionDetailsOrderId];
    [aCoder encodeObject:_grossAmount forKey:kMidtransPaymentRequestV2TransactionDetailsGrossAmount];
}

- (id)copyWithZone:(NSZone *)zone
{
    MidtransPaymentRequestV2TransactionDetails *copy = [[MidtransPaymentRequestV2TransactionDetails alloc] init];
    
    if (copy) {

        copy.orderId = [self.orderId copyWithZone:zone];
        copy.grossAmount = [self.grossAmount copyWithZone:zone];
    }
    
    return copy;
}


@end
