//
//  MidtransPaymentRequestV2Installment2.m
//
//  Created by Zanna Simarmata on 1/3/17
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "MidtransPaymentRequestV2Installment2.h"
#import "MidtransPaymentRequestV2Installment.h"


NSString *const kMidtransPaymentRequestV2Installment2Installment = @"installment";


@interface MidtransPaymentRequestV2Installment2 ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation MidtransPaymentRequestV2Installment2

@synthesize installment = _installment;


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
            self.installment = [MidtransPaymentRequestV2Installment modelObjectWithDictionary:[dict objectForKey:kMidtransPaymentRequestV2Installment2Installment]];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[self.installment dictionaryRepresentation] forKey:kMidtransPaymentRequestV2Installment2Installment];

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

    self.installment = [aDecoder decodeObjectForKey:kMidtransPaymentRequestV2Installment2Installment];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_installment forKey:kMidtransPaymentRequestV2Installment2Installment];
}

- (id)copyWithZone:(NSZone *)zone
{
    MidtransPaymentRequestV2Installment2 *copy = [[MidtransPaymentRequestV2Installment2 alloc] init];
    
    if (copy) {

        copy.installment = [self.installment copyWithZone:zone];
    }
    
    return copy;
}


@end
