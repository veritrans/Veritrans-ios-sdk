//
//  PaymentRequestResponse.m
//
//  Created by Arie  on 7/19/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "MidtransPaymentRequestResponse.h"
#import "MidtransPaymentRequestTransactionData.h"
#import "MidtransPaymentRequestMerchantData.h"


NSString *const kPaymentRequestResponseTransactionData = @"transactionData";
NSString *const kPaymentRequestResponseMerchantData = @"merchantData";


@interface MidtransPaymentRequestResponse ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation MidtransPaymentRequestResponse

@synthesize transactionData = _transactionData;
@synthesize merchantData = _merchantData;


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
            self.transactionData = [MidtransPaymentRequestTransactionData modelObjectWithDictionary:[dict objectForKey:kPaymentRequestResponseTransactionData]];
            self.merchantData = [MidtransPaymentRequestMerchantData modelObjectWithDictionary:[dict objectForKey:kPaymentRequestResponseMerchantData]];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[self.transactionData dictionaryRepresentation] forKey:kPaymentRequestResponseTransactionData];
    [mutableDict setValue:[self.merchantData dictionaryRepresentation] forKey:kPaymentRequestResponseMerchantData];

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

    self.transactionData = [aDecoder decodeObjectForKey:kPaymentRequestResponseTransactionData];
    self.merchantData = [aDecoder decodeObjectForKey:kPaymentRequestResponseMerchantData];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_transactionData forKey:kPaymentRequestResponseTransactionData];
    [aCoder encodeObject:_merchantData forKey:kPaymentRequestResponseMerchantData];
}

- (id)copyWithZone:(NSZone *)zone
{
    MidtransPaymentRequestResponse *copy = [[MidtransPaymentRequestResponse alloc] init];
    
    if (copy) {

        copy.transactionData = [self.transactionData copyWithZone:zone];
        copy.merchantData = [self.merchantData copyWithZone:zone];
    }
    
    return copy;
}


@end
