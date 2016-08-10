//
//  PaymentRequestTransactionDetails.m
//
//  Created by Arie  on 7/19/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "PaymentRequestTransactionDetails.h"


NSString *const kPaymentRequestTransactionDetailsOrderId = @"orderId";
NSString *const kPaymentRequestTransactionDetailsAmount = @"amount";


@interface PaymentRequestTransactionDetails ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation PaymentRequestTransactionDetails

@synthesize orderId = _orderId;
@synthesize amount = _amount;


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
        self.orderId = [self objectOrNilForKey:kPaymentRequestTransactionDetailsOrderId fromDictionary:dict];
        self.amount = [self objectOrNilForKey:kPaymentRequestTransactionDetailsAmount fromDictionary:dict];
        
    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.orderId forKey:kPaymentRequestTransactionDetailsOrderId];
    [mutableDict setValue:self.amount forKey:kPaymentRequestTransactionDetailsAmount];
    
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
    
    self.orderId = [aDecoder decodeObjectForKey:kPaymentRequestTransactionDetailsOrderId];
    self.amount = [aDecoder decodeObjectForKey:kPaymentRequestTransactionDetailsAmount];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
    [aCoder encodeObject:_orderId forKey:kPaymentRequestTransactionDetailsOrderId];
    [aCoder encodeObject:_amount forKey:kPaymentRequestTransactionDetailsAmount];
}

- (id)copyWithZone:(NSZone *)zone
{
    PaymentRequestTransactionDetails *copy = [[PaymentRequestTransactionDetails alloc] init];
    
    if (copy) {
        
        copy.orderId = [self.orderId copyWithZone:zone];
        copy.amount = [self.amount copyWithZone:zone];
    }
    
    return copy;
}


@end
