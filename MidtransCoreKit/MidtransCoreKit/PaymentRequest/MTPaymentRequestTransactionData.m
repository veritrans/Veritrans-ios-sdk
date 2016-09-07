//
//  PaymentRequestTransactionData.m
//
//  Created by Arie  on 7/19/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "MTPaymentRequestTransactionData.h"
#import "MTPaymentRequestItemDetails.h"
#import "MTPaymentRequestCustomerDetails.h"
#import "MTPaymentRequestTransactionDetails.h"
#import "MTPaymentRequestPaymentOptions.h"
#import "MTPaymentRequestBankTransfer.h"


NSString *const kPaymentRequestTransactionDataEnabledPayments = @"enabledPayments";
NSString *const kPaymentRequestTransactionDataItemDetails = @"itemDetails";
NSString *const kPaymentRequestTransactionDataCustomerDetails = @"customerDetails";
NSString *const kPaymentRequestTransactionDataId = @"id";
NSString *const kPaymentRequestTransactionDataTransactionDetails = @"transactionDetails";
NSString *const kPaymentRequestTransactionDataPaymentOptions = @"paymentOptions";
NSString *const kPaymentRequestTransactionDataTransactionId = @"transactionId";
NSString *const kPaymentRequestTransactionDataKind = @"kind";
NSString *const kPaymentRequestTransactionDataBankTransfer = @"bankTransfer";


@interface MTPaymentRequestTransactionData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation MTPaymentRequestTransactionData

@synthesize enabledPayments = _enabledPayments;
@synthesize itemDetails = _itemDetails;
@synthesize customerDetails = _customerDetails;
@synthesize transactionDataIdentifier = _transactionDataIdentifier;
@synthesize transactionDetails = _transactionDetails;
@synthesize paymentOptions = _paymentOptions;
@synthesize transactionId = _transactionId;
@synthesize kind = _kind;
@synthesize bankTransfer = _bankTransfer;


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
        self.enabledPayments = [self objectOrNilForKey:kPaymentRequestTransactionDataEnabledPayments fromDictionary:dict];
        NSObject *receivedPaymentRequestItemDetails = [dict objectForKey:kPaymentRequestTransactionDataItemDetails];
        NSMutableArray *parsedPaymentRequestItemDetails = [NSMutableArray array];
        if ([receivedPaymentRequestItemDetails isKindOfClass:[NSArray class]]) {
            for (NSDictionary *item in (NSArray *)receivedPaymentRequestItemDetails) {
                if ([item isKindOfClass:[NSDictionary class]]) {
                    [parsedPaymentRequestItemDetails addObject:[MTPaymentRequestItemDetails modelObjectWithDictionary:item]];
                }
            }
        } else if ([receivedPaymentRequestItemDetails isKindOfClass:[NSDictionary class]]) {
            [parsedPaymentRequestItemDetails addObject:[MTPaymentRequestItemDetails modelObjectWithDictionary:(NSDictionary *)receivedPaymentRequestItemDetails]];
        }
        
        self.itemDetails = [NSArray arrayWithArray:parsedPaymentRequestItemDetails];
        self.customerDetails = [MTPaymentRequestCustomerDetails modelObjectWithDictionary:[dict objectForKey:kPaymentRequestTransactionDataCustomerDetails]];
        self.transactionDataIdentifier = [self objectOrNilForKey:kPaymentRequestTransactionDataId fromDictionary:dict];
        self.transactionDetails = [MTPaymentRequestTransactionDetails modelObjectWithDictionary:[dict objectForKey:kPaymentRequestTransactionDataTransactionDetails]];
        self.paymentOptions = [MTPaymentRequestPaymentOptions modelObjectWithDictionary:[dict objectForKey:kPaymentRequestTransactionDataPaymentOptions]];
        self.transactionId = [self objectOrNilForKey:kPaymentRequestTransactionDataTransactionId fromDictionary:dict];
        self.kind = [self objectOrNilForKey:kPaymentRequestTransactionDataKind fromDictionary:dict];
        self.bankTransfer = [MTPaymentRequestBankTransfer modelObjectWithDictionary:[dict objectForKey:kPaymentRequestTransactionDataBankTransfer]];
        
    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    NSMutableArray *tempArrayForEnabledPayments = [NSMutableArray array];
    for (NSObject *subArrayObject in self.enabledPayments) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForEnabledPayments addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForEnabledPayments addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForEnabledPayments] forKey:kPaymentRequestTransactionDataEnabledPayments];
    NSMutableArray *tempArrayForItemDetails = [NSMutableArray array];
    for (NSObject *subArrayObject in self.itemDetails) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForItemDetails addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForItemDetails addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForItemDetails] forKey:kPaymentRequestTransactionDataItemDetails];
    [mutableDict setValue:[self.customerDetails dictionaryRepresentation] forKey:kPaymentRequestTransactionDataCustomerDetails];
    [mutableDict setValue:self.transactionDataIdentifier forKey:kPaymentRequestTransactionDataId];
    [mutableDict setValue:[self.transactionDetails dictionaryRepresentation] forKey:kPaymentRequestTransactionDataTransactionDetails];
    [mutableDict setValue:[self.paymentOptions dictionaryRepresentation] forKey:kPaymentRequestTransactionDataPaymentOptions];
    [mutableDict setValue:self.transactionId forKey:kPaymentRequestTransactionDataTransactionId];
    [mutableDict setValue:self.kind forKey:kPaymentRequestTransactionDataKind];
    [mutableDict setValue:[self.bankTransfer dictionaryRepresentation] forKey:kPaymentRequestTransactionDataBankTransfer];
    
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
    
    self.enabledPayments = [aDecoder decodeObjectForKey:kPaymentRequestTransactionDataEnabledPayments];
    self.itemDetails = [aDecoder decodeObjectForKey:kPaymentRequestTransactionDataItemDetails];
    self.customerDetails = [aDecoder decodeObjectForKey:kPaymentRequestTransactionDataCustomerDetails];
    self.transactionDataIdentifier = [aDecoder decodeObjectForKey:kPaymentRequestTransactionDataId];
    self.transactionDetails = [aDecoder decodeObjectForKey:kPaymentRequestTransactionDataTransactionDetails];
    self.paymentOptions = [aDecoder decodeObjectForKey:kPaymentRequestTransactionDataPaymentOptions];
    self.transactionId = [aDecoder decodeObjectForKey:kPaymentRequestTransactionDataTransactionId];
    self.kind = [aDecoder decodeObjectForKey:kPaymentRequestTransactionDataKind];
    self.bankTransfer = [aDecoder decodeObjectForKey:kPaymentRequestTransactionDataBankTransfer];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
    [aCoder encodeObject:_enabledPayments forKey:kPaymentRequestTransactionDataEnabledPayments];
    [aCoder encodeObject:_itemDetails forKey:kPaymentRequestTransactionDataItemDetails];
    [aCoder encodeObject:_customerDetails forKey:kPaymentRequestTransactionDataCustomerDetails];
    [aCoder encodeObject:_transactionDataIdentifier forKey:kPaymentRequestTransactionDataId];
    [aCoder encodeObject:_transactionDetails forKey:kPaymentRequestTransactionDataTransactionDetails];
    [aCoder encodeObject:_paymentOptions forKey:kPaymentRequestTransactionDataPaymentOptions];
    [aCoder encodeObject:_transactionId forKey:kPaymentRequestTransactionDataTransactionId];
    [aCoder encodeObject:_kind forKey:kPaymentRequestTransactionDataKind];
    [aCoder encodeObject:_bankTransfer forKey:kPaymentRequestTransactionDataBankTransfer];
}

- (id)copyWithZone:(NSZone *)zone
{
    MTPaymentRequestTransactionData *copy = [[MTPaymentRequestTransactionData alloc] init];
    
    if (copy) {
        
        copy.enabledPayments = [self.enabledPayments copyWithZone:zone];
        copy.itemDetails = [self.itemDetails copyWithZone:zone];
        copy.customerDetails = [self.customerDetails copyWithZone:zone];
        copy.transactionDataIdentifier = [self.transactionDataIdentifier copyWithZone:zone];
        copy.transactionDetails = [self.transactionDetails copyWithZone:zone];
        copy.paymentOptions = [self.paymentOptions copyWithZone:zone];
        copy.transactionId = [self.transactionId copyWithZone:zone];
        copy.kind = [self.kind copyWithZone:zone];
        copy.bankTransfer = [self.bankTransfer copyWithZone:zone];
    }
    
    return copy;
}


@end
