//
//  MidtransPaymentRequestV2Response.m
//
//  Created by Ratna Kumalasari on 10/25/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "MidtransPaymentRequestV2Response.h"
#import "MidtransPaymentRequestV2TransactionDetails.h"
#import "MidtransPaymentRequestV2EnabledPayments.h"
#import "MidtransPaymentRequestV2CreditCard.h"
#import "MidtransPaymentRequestV2Merchant.h"
#import "MidtransPaymentRequestV2CustomerDetails.h"
#import "MidtransPaymentRequestV2ItemDetails.h"
#import "MidtransPaymentRequestV2Callbacks.h"
#import "MidtransTransactionExpire.h"
#import "MidtransPromoDataModels.h"

NSString *const kMidtransPaymentRequestV2ResponseTransactionDetails = @"transaction_details";
NSString *const kMidtransPaymentRequestV2ResponseEnabledPayments = @"enabled_payments";
NSString *const kMidtransPaymentRequestV2ResponseCreditCard = @"credit_card";
NSString *const kMidtransPaymentRequestV2ResponseMerchant = @"merchant";
NSString *const kMidtransPaymentRequestV2ResponseCustomerDetails = @"customer_details";
NSString *const kMidtransPaymentRequestV2ResponseItemDetails = @"item_details";
NSString *const kMidtransPaymentRequestV2ResponseToken = @"token";
NSString *const kMidtransPaymentRequestV2ResponseCallbacks = @"callbacks";
NSString *const kMIdtransPaymentRequestV2ResponseExpire  = @"expiry";
NSString *const KMidtransPaymentRequestV2ResponseCustomField =@"custom";
NSString *const kMidtransCheckoutResponsePromo = @"promo_details";

@interface MidtransPaymentRequestV2Response ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation MidtransPaymentRequestV2Response

@synthesize transactionDetails = _transactionDetails;
@synthesize enabledPayments = _enabledPayments;
@synthesize creditCard = _creditCard;
@synthesize merchant = _merchant;
@synthesize customerDetails = _customerDetails;
@synthesize itemDetails = _itemDetails;
@synthesize token = _token;
@synthesize promos = _promos;
@synthesize callbacks = _callbacks;


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
        self.transactionDetails = [MidtransPaymentRequestV2TransactionDetails modelObjectWithDictionary:[dict objectForKey:kMidtransPaymentRequestV2ResponseTransactionDetails]];
        NSObject *receivedMidtransPaymentRequestV2EnabledPayments = [dict objectForKey:kMidtransPaymentRequestV2ResponseEnabledPayments];
        NSMutableArray *parsedMidtransPaymentRequestV2EnabledPayments = [NSMutableArray array];
        if ([receivedMidtransPaymentRequestV2EnabledPayments isKindOfClass:[NSArray class]]) {
            for (NSDictionary *item in (NSArray *)receivedMidtransPaymentRequestV2EnabledPayments) {
                if ([item isKindOfClass:[NSDictionary class]]) {
                    [parsedMidtransPaymentRequestV2EnabledPayments addObject:[MidtransPaymentRequestV2EnabledPayments modelObjectWithDictionary:item]];
                }
            }
        } else if ([receivedMidtransPaymentRequestV2EnabledPayments isKindOfClass:[NSDictionary class]]) {
            [parsedMidtransPaymentRequestV2EnabledPayments addObject:[MidtransPaymentRequestV2EnabledPayments modelObjectWithDictionary:(NSDictionary *)receivedMidtransPaymentRequestV2EnabledPayments]];
        }
        
        self.enabledPayments = [NSArray arrayWithArray:parsedMidtransPaymentRequestV2EnabledPayments];
        self.creditCard = [MidtransPaymentRequestV2CreditCard modelObjectWithDictionary:[dict objectForKey:kMidtransPaymentRequestV2ResponseCreditCard]];
        self.merchant = [MidtransPaymentRequestV2Merchant modelObjectWithDictionary:[dict objectForKey:kMidtransPaymentRequestV2ResponseMerchant]];
        self.customerDetails = [MidtransPaymentRequestV2CustomerDetails modelObjectWithDictionary:[dict objectForKey:kMidtransPaymentRequestV2ResponseCustomerDetails]];
        NSObject *receivedMidtransPaymentRequestV2ItemDetails = [dict objectForKey:kMidtransPaymentRequestV2ResponseItemDetails];
        NSMutableArray *parsedMidtransPaymentRequestV2ItemDetails = [NSMutableArray array];
        if ([receivedMidtransPaymentRequestV2ItemDetails isKindOfClass:[NSArray class]]) {
            for (NSDictionary *item in (NSArray *)receivedMidtransPaymentRequestV2ItemDetails) {
                if ([item isKindOfClass:[NSDictionary class]]) {
                    [parsedMidtransPaymentRequestV2ItemDetails addObject:[MidtransPaymentRequestV2ItemDetails modelObjectWithDictionary:item]];
                }
            }
        } else if ([receivedMidtransPaymentRequestV2ItemDetails isKindOfClass:[NSDictionary class]]) {
            [parsedMidtransPaymentRequestV2ItemDetails addObject:[MidtransPaymentRequestV2ItemDetails modelObjectWithDictionary:(NSDictionary *)receivedMidtransPaymentRequestV2ItemDetails]];
        }
        
        self.itemDetails = [NSArray arrayWithArray:parsedMidtransPaymentRequestV2ItemDetails];
        self.token = [self objectOrNilForKey:kMidtransPaymentRequestV2ResponseToken fromDictionary:dict];
        self.callbacks = [MidtransPaymentRequestV2Callbacks modelObjectWithDictionary:[dict objectForKey:kMidtransPaymentRequestV2ResponseCallbacks]];
        self.expire = [MidtransTransactionExpire modelObjectWithDictionary:[dict objectForKey:kMIdtransPaymentRequestV2ResponseExpire]];
        self.custom  = [self objectOrNilForKey:KMidtransPaymentRequestV2ResponseCustomField fromDictionary:dict];
        self.promos = [MidtransPromoPromoDetails modelObjectWithDictionary:[dict objectForKey:kMidtransCheckoutResponsePromo]];
    }
    
    
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[self.transactionDetails dictionaryRepresentation] forKey:kMidtransPaymentRequestV2ResponseTransactionDetails];
    NSMutableArray *tempArrayForEnabledPayments = [NSMutableArray array];
    for (NSObject *subArrayObject in self.enabledPayments) {
        if ([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForEnabledPayments addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForEnabledPayments addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForEnabledPayments] forKey:kMidtransPaymentRequestV2ResponseEnabledPayments];
    [mutableDict setValue:[self.creditCard dictionaryRepresentation] forKey:kMidtransPaymentRequestV2ResponseCreditCard];
    [mutableDict setValue:[self.merchant dictionaryRepresentation] forKey:kMidtransPaymentRequestV2ResponseMerchant];
    [mutableDict setValue:[self.customerDetails dictionaryRepresentation] forKey:kMidtransPaymentRequestV2ResponseCustomerDetails];
    NSMutableArray *tempArrayForItemDetails = [NSMutableArray array];
    for (NSObject *subArrayObject in self.itemDetails) {
        if ([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForItemDetails addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForItemDetails addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForItemDetails] forKey:kMidtransPaymentRequestV2ResponseItemDetails];
    [mutableDict setValue:self.token forKey:kMidtransPaymentRequestV2ResponseToken];
    [mutableDict setValue:[self.callbacks dictionaryRepresentation] forKey:kMidtransPaymentRequestV2ResponseCallbacks];
    
   
    [mutableDict setValue:self.promos forKey:kMidtransCheckoutResponsePromo];
    
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

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    self.promos = [aDecoder decodeObjectForKey:kMidtransCheckoutResponsePromo];
    self.transactionDetails = [aDecoder decodeObjectForKey:kMidtransPaymentRequestV2ResponseTransactionDetails];
    self.enabledPayments = [aDecoder decodeObjectForKey:kMidtransPaymentRequestV2ResponseEnabledPayments];
    self.creditCard = [aDecoder decodeObjectForKey:kMidtransPaymentRequestV2ResponseCreditCard];
    self.merchant = [aDecoder decodeObjectForKey:kMidtransPaymentRequestV2ResponseMerchant];
    self.customerDetails = [aDecoder decodeObjectForKey:kMidtransPaymentRequestV2ResponseCustomerDetails];
    self.itemDetails = [aDecoder decodeObjectForKey:kMidtransPaymentRequestV2ResponseItemDetails];
    self.token = [aDecoder decodeObjectForKey:kMidtransPaymentRequestV2ResponseToken];
    self.callbacks = [aDecoder decodeObjectForKey:kMidtransPaymentRequestV2ResponseCallbacks];
    self.expire = [aDecoder decodeObjectForKey:kMIdtransPaymentRequestV2ResponseExpire];
    self.custom = [aDecoder decodeObjectForKey:KMidtransPaymentRequestV2ResponseCustomField];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_promos forKey:kMidtransCheckoutResponsePromo];
    [aCoder encodeObject:_transactionDetails forKey:kMidtransPaymentRequestV2ResponseTransactionDetails];
    [aCoder encodeObject:_enabledPayments forKey:kMidtransPaymentRequestV2ResponseEnabledPayments];
    [aCoder encodeObject:_creditCard forKey:kMidtransPaymentRequestV2ResponseCreditCard];
    [aCoder encodeObject:_merchant forKey:kMidtransPaymentRequestV2ResponseMerchant];
    [aCoder encodeObject:_customerDetails forKey:kMidtransPaymentRequestV2ResponseCustomerDetails];
    [aCoder encodeObject:_itemDetails forKey:kMidtransPaymentRequestV2ResponseItemDetails];
    [aCoder encodeObject:_token forKey:kMidtransPaymentRequestV2ResponseToken];
    [aCoder encodeObject:_callbacks forKey:kMidtransPaymentRequestV2ResponseCallbacks];
}

- (id)copyWithZone:(NSZone *)zone
{
    MidtransPaymentRequestV2Response *copy = [[MidtransPaymentRequestV2Response alloc] init];
    
    if (copy) {
       // copy.promos = [self.promos copyWithZone:zone];
        copy.transactionDetails = [self.transactionDetails copyWithZone:zone];
        copy.enabledPayments = [self.enabledPayments copyWithZone:zone];
        copy.creditCard = [self.creditCard copyWithZone:zone];
        copy.merchant = [self.merchant copyWithZone:zone];
        copy.customerDetails = [self.customerDetails copyWithZone:zone];
        copy.itemDetails = [self.itemDetails copyWithZone:zone];
        copy.token = [self.token copyWithZone:zone];
        copy.callbacks = [self.callbacks copyWithZone:zone];
    }
    
    return copy;
}


@end
