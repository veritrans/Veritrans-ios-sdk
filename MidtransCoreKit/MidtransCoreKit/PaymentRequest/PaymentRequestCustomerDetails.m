//
//  PaymentRequestCustomerDetails.m
//
//  Created by Arie  on 7/19/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "PaymentRequestCustomerDetails.h"


NSString *const kPaymentRequestCustomerDetailsEmail = @"email";
NSString *const kPaymentRequestCustomerDetailsPhone = @"phone";
NSString *const kPaymentRequestCustomerDetailsName = @"name";
NSString *const kPaymentRequestCustomerDetailsAddress = @"address";


@interface PaymentRequestCustomerDetails ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation PaymentRequestCustomerDetails

@synthesize email = _email;
@synthesize phone = _phone;
@synthesize name = _name;
@synthesize address = _address;


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
            self.email = [self objectOrNilForKey:kPaymentRequestCustomerDetailsEmail fromDictionary:dict];
            self.phone = [self objectOrNilForKey:kPaymentRequestCustomerDetailsPhone fromDictionary:dict];
            self.name = [self objectOrNilForKey:kPaymentRequestCustomerDetailsName fromDictionary:dict];
            self.address = [self objectOrNilForKey:kPaymentRequestCustomerDetailsAddress fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.email forKey:kPaymentRequestCustomerDetailsEmail];
    [mutableDict setValue:self.phone forKey:kPaymentRequestCustomerDetailsPhone];
    [mutableDict setValue:self.name forKey:kPaymentRequestCustomerDetailsName];
    [mutableDict setValue:self.address forKey:kPaymentRequestCustomerDetailsAddress];

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

    self.email = [aDecoder decodeObjectForKey:kPaymentRequestCustomerDetailsEmail];
    self.phone = [aDecoder decodeObjectForKey:kPaymentRequestCustomerDetailsPhone];
    self.name = [aDecoder decodeObjectForKey:kPaymentRequestCustomerDetailsName];
    self.address = [aDecoder decodeObjectForKey:kPaymentRequestCustomerDetailsAddress];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_email forKey:kPaymentRequestCustomerDetailsEmail];
    [aCoder encodeObject:_phone forKey:kPaymentRequestCustomerDetailsPhone];
    [aCoder encodeObject:_name forKey:kPaymentRequestCustomerDetailsName];
    [aCoder encodeObject:_address forKey:kPaymentRequestCustomerDetailsAddress];
}

- (id)copyWithZone:(NSZone *)zone
{
    PaymentRequestCustomerDetails *copy = [[PaymentRequestCustomerDetails alloc] init];
    
    if (copy) {

        copy.email = [self.email copyWithZone:zone];
        copy.phone = [self.phone copyWithZone:zone];
        copy.name = [self.name copyWithZone:zone];
        copy.address = [self.address copyWithZone:zone];
    }
    
    return copy;
}


@end
