//
//  MidtransPaymentRequestV2CustomerDetails.m
//
//  Created by Ratna Kumalasari on 10/25/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "MidtransPaymentRequestV2CustomerDetails.h"
#import "MidtransPaymentRequestV2BillingAddress.h"
#import "MidtransPaymentRequestV2ShippingAddress.h"


NSString *const kMidtransPaymentRequestV2CustomerDetailsEmail = @"email";
NSString *const kMidtransPaymentRequestV2CustomerDetailsPhone = @"phone";
NSString *const kMidtransPaymentRequestV2CustomerDetailsLastName = @"last_name";
NSString *const kMidtransPaymentRequestV2CustomerDetailsBillingAddress = @"billing_address";
NSString *const kMidtransPaymentRequestV2CustomerDetailsShippingAddress = @"shipping_address";
NSString *const kMidtransPaymentRequestV2CustomerDetailsFirstName = @"first_name";


@interface MidtransPaymentRequestV2CustomerDetails ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation MidtransPaymentRequestV2CustomerDetails

@synthesize email = _email;
@synthesize phone = _phone;
@synthesize lastName = _lastName;
@synthesize billingAddress = _billingAddress;
@synthesize shippingAddress = _shippingAddress;
@synthesize firstName = _firstName;


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
            self.email = [self objectOrNilForKey:kMidtransPaymentRequestV2CustomerDetailsEmail fromDictionary:dict];
            self.phone = [self objectOrNilForKey:kMidtransPaymentRequestV2CustomerDetailsPhone fromDictionary:dict];
            self.lastName = [self objectOrNilForKey:kMidtransPaymentRequestV2CustomerDetailsLastName fromDictionary:dict];
            self.billingAddress = [MidtransPaymentRequestV2BillingAddress modelObjectWithDictionary:[dict objectForKey:kMidtransPaymentRequestV2CustomerDetailsBillingAddress]];
            self.shippingAddress = [MidtransPaymentRequestV2ShippingAddress modelObjectWithDictionary:[dict objectForKey:kMidtransPaymentRequestV2CustomerDetailsShippingAddress]];
            self.firstName = [self objectOrNilForKey:kMidtransPaymentRequestV2CustomerDetailsFirstName fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.email forKey:kMidtransPaymentRequestV2CustomerDetailsEmail];
    [mutableDict setValue:self.phone forKey:kMidtransPaymentRequestV2CustomerDetailsPhone];
    [mutableDict setValue:self.lastName forKey:kMidtransPaymentRequestV2CustomerDetailsLastName];
    [mutableDict setValue:[self.billingAddress dictionaryRepresentation] forKey:kMidtransPaymentRequestV2CustomerDetailsBillingAddress];
    [mutableDict setValue:[self.shippingAddress dictionaryRepresentation] forKey:kMidtransPaymentRequestV2CustomerDetailsShippingAddress];
    [mutableDict setValue:self.firstName forKey:kMidtransPaymentRequestV2CustomerDetailsFirstName];

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

    self.email = [aDecoder decodeObjectForKey:kMidtransPaymentRequestV2CustomerDetailsEmail];
    self.phone = [aDecoder decodeObjectForKey:kMidtransPaymentRequestV2CustomerDetailsPhone];
    self.lastName = [aDecoder decodeObjectForKey:kMidtransPaymentRequestV2CustomerDetailsLastName];
    self.billingAddress = [aDecoder decodeObjectForKey:kMidtransPaymentRequestV2CustomerDetailsBillingAddress];
    self.shippingAddress = [aDecoder decodeObjectForKey:kMidtransPaymentRequestV2CustomerDetailsShippingAddress];
    self.firstName = [aDecoder decodeObjectForKey:kMidtransPaymentRequestV2CustomerDetailsFirstName];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_email forKey:kMidtransPaymentRequestV2CustomerDetailsEmail];
    [aCoder encodeObject:_phone forKey:kMidtransPaymentRequestV2CustomerDetailsPhone];
    [aCoder encodeObject:_lastName forKey:kMidtransPaymentRequestV2CustomerDetailsLastName];
    [aCoder encodeObject:_billingAddress forKey:kMidtransPaymentRequestV2CustomerDetailsBillingAddress];
    [aCoder encodeObject:_shippingAddress forKey:kMidtransPaymentRequestV2CustomerDetailsShippingAddress];
    [aCoder encodeObject:_firstName forKey:kMidtransPaymentRequestV2CustomerDetailsFirstName];
}

- (id)copyWithZone:(NSZone *)zone
{
    MidtransPaymentRequestV2CustomerDetails *copy = [[MidtransPaymentRequestV2CustomerDetails alloc] init];
    
    if (copy) {

        copy.email = [self.email copyWithZone:zone];
        copy.phone = [self.phone copyWithZone:zone];
        copy.lastName = [self.lastName copyWithZone:zone];
        copy.billingAddress = [self.billingAddress copyWithZone:zone];
        copy.shippingAddress = [self.shippingAddress copyWithZone:zone];
        copy.firstName = [self.firstName copyWithZone:zone];
    }
    
    return copy;
}


@end
