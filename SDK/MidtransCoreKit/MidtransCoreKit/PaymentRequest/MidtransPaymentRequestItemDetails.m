//
//  PaymentRequestItemDetails.m
//
//  Created by Arie  on 7/19/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "MidtransPaymentRequestItemDetails.h"


NSString *const kPaymentRequestItemDetailsName = @"name";
NSString *const kPaymentRequestItemDetailsPrice = @"price";
NSString *const kPaymentRequestItemDetailsQuantity = @"quantity";


@interface MidtransPaymentRequestItemDetails ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation MidtransPaymentRequestItemDetails

@synthesize name = _name;
@synthesize price = _price;
@synthesize quantity = _quantity;


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
            self.name = [self objectOrNilForKey:kPaymentRequestItemDetailsName fromDictionary:dict];
            self.price = [self objectOrNilForKey:kPaymentRequestItemDetailsPrice fromDictionary:dict];
            self.quantity = [[self objectOrNilForKey:kPaymentRequestItemDetailsQuantity fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.name forKey:kPaymentRequestItemDetailsName];
    [mutableDict setValue:self.price forKey:kPaymentRequestItemDetailsPrice];
    [mutableDict setValue:[NSNumber numberWithDouble:self.quantity] forKey:kPaymentRequestItemDetailsQuantity];

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

    self.name = [aDecoder decodeObjectForKey:kPaymentRequestItemDetailsName];
    self.price = [aDecoder decodeObjectForKey:kPaymentRequestItemDetailsPrice];
    self.quantity = [aDecoder decodeDoubleForKey:kPaymentRequestItemDetailsQuantity];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_name forKey:kPaymentRequestItemDetailsName];
    [aCoder encodeObject:_price forKey:kPaymentRequestItemDetailsPrice];
    [aCoder encodeDouble:_quantity forKey:kPaymentRequestItemDetailsQuantity];
}

- (id)copyWithZone:(NSZone *)zone
{
    MidtransPaymentRequestItemDetails *copy = [[MidtransPaymentRequestItemDetails alloc] init];
    
    if (copy) {

        copy.name = [self.name copyWithZone:zone];
        copy.price = [self.price copyWithZone:zone];
        copy.quantity = self.quantity;
    }
    
    return copy;
}


@end
