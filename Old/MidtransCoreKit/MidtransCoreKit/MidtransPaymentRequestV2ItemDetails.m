//
//  MidtransPaymentRequestV2ItemDetails.m
//
//  Created by Ratna Kumalasari on 10/25/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "MidtransPaymentRequestV2ItemDetails.h"


NSString *const kMidtransPaymentRequestV2ItemDetailsQuantity = @"quantity";
NSString *const kMidtransPaymentRequestV2ItemDetailsId = @"id";
NSString *const kMidtransPaymentRequestV2ItemDetailsName = @"name";
NSString *const kMidtransPaymentRequestV2ItemDetailsPrice = @"price";


@interface MidtransPaymentRequestV2ItemDetails ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation MidtransPaymentRequestV2ItemDetails

@synthesize quantity = _quantity;
@synthesize itemDetailsIdentifier = _itemDetailsIdentifier;
@synthesize name = _name;
@synthesize price = _price;


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
            self.quantity = [[self objectOrNilForKey:kMidtransPaymentRequestV2ItemDetailsQuantity fromDictionary:dict] doubleValue];
            self.itemDetailsIdentifier = [self objectOrNilForKey:kMidtransPaymentRequestV2ItemDetailsId fromDictionary:dict];
            self.name = [self objectOrNilForKey:kMidtransPaymentRequestV2ItemDetailsName fromDictionary:dict];
            self.price = [[self objectOrNilForKey:kMidtransPaymentRequestV2ItemDetailsPrice fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.quantity] forKey:kMidtransPaymentRequestV2ItemDetailsQuantity];
    [mutableDict setValue:self.itemDetailsIdentifier forKey:kMidtransPaymentRequestV2ItemDetailsId];
    [mutableDict setValue:self.name forKey:kMidtransPaymentRequestV2ItemDetailsName];
    [mutableDict setValue:[NSNumber numberWithDouble:self.price] forKey:kMidtransPaymentRequestV2ItemDetailsPrice];

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

    self.quantity = [aDecoder decodeDoubleForKey:kMidtransPaymentRequestV2ItemDetailsQuantity];
    self.itemDetailsIdentifier = [aDecoder decodeObjectForKey:kMidtransPaymentRequestV2ItemDetailsId];
    self.name = [aDecoder decodeObjectForKey:kMidtransPaymentRequestV2ItemDetailsName];
    self.price = [aDecoder decodeDoubleForKey:kMidtransPaymentRequestV2ItemDetailsPrice];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_quantity forKey:kMidtransPaymentRequestV2ItemDetailsQuantity];
    [aCoder encodeObject:_itemDetailsIdentifier forKey:kMidtransPaymentRequestV2ItemDetailsId];
    [aCoder encodeObject:_name forKey:kMidtransPaymentRequestV2ItemDetailsName];
    [aCoder encodeDouble:_price forKey:kMidtransPaymentRequestV2ItemDetailsPrice];
}

- (id)copyWithZone:(NSZone *)zone
{
    MidtransPaymentRequestV2ItemDetails *copy = [[MidtransPaymentRequestV2ItemDetails alloc] init];
    
    if (copy) {

        copy.quantity = self.quantity;
        copy.itemDetailsIdentifier = [self.itemDetailsIdentifier copyWithZone:zone];
        copy.name = [self.name copyWithZone:zone];
        copy.price = self.price;
    }
    
    return copy;
}


@end
