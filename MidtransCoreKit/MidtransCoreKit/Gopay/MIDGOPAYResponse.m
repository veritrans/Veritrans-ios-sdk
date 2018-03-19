//
//  MIDGOPAYResponse.m
//
//  Created by Ratna Kumalasari on 11/28/17
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "MIDGOPAYResponse.h"


NSString *const kMIDGOPAYResponseFinishRedirectUrl = @"finish_redirect_url";
NSString *const kMIDGOPAYResponseTransactionStatus = @"transaction_status";
NSString *const kMIDGOPAYResponsePaymentType = @"payment_type";
NSString *const kMIDGOPAYResponseTransactionId = @"transaction_id";
NSString *const kMIDGOPAYResponseGrossAmount = @"gross_amount";
NSString *const kMIDGOPAYResponseOrderId = @"order_id";
NSString *const kMIDGOPAYResponseQrCodeUrl = @"qr_code_url";
NSString *const kMIDGOPAYResponseStatusMessage = @"status_message";
NSString *const kMIDGOPAYResponseDeeplinkUrl = @"deeplink_url";
NSString *const kMIDGOPAYResponseFraudStatus = @"fraud_status";
NSString *const kMIDGOPAYResponseStatusCode = @"status_code";
NSString *const kMIDGOPAYResponseTransactionTime = @"transaction_time";


@interface MIDGOPAYResponse ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation MIDGOPAYResponse

@synthesize finishRedirectUrl = _finishRedirectUrl;
@synthesize transactionStatus = _transactionStatus;
@synthesize paymentType = _paymentType;
@synthesize transactionId = _transactionId;
@synthesize grossAmount = _grossAmount;
@synthesize orderId = _orderId;
@synthesize qrCodeUrl = _qrCodeUrl;
@synthesize statusMessage = _statusMessage;
@synthesize deeplinkUrl = _deeplinkUrl;
@synthesize fraudStatus = _fraudStatus;
@synthesize statusCode = _statusCode;
@synthesize transactionTime = _transactionTime;


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
            self.finishRedirectUrl = [self objectOrNilForKey:kMIDGOPAYResponseFinishRedirectUrl fromDictionary:dict];
            self.transactionStatus = [self objectOrNilForKey:kMIDGOPAYResponseTransactionStatus fromDictionary:dict];
            self.paymentType = [self objectOrNilForKey:kMIDGOPAYResponsePaymentType fromDictionary:dict];
            self.transactionId = [self objectOrNilForKey:kMIDGOPAYResponseTransactionId fromDictionary:dict];
            self.grossAmount = [self objectOrNilForKey:kMIDGOPAYResponseGrossAmount fromDictionary:dict];
            self.orderId = [self objectOrNilForKey:kMIDGOPAYResponseOrderId fromDictionary:dict];
            self.qrCodeUrl = [self objectOrNilForKey:kMIDGOPAYResponseQrCodeUrl fromDictionary:dict];
            self.statusMessage = [self objectOrNilForKey:kMIDGOPAYResponseStatusMessage fromDictionary:dict];
            self.deeplinkUrl = [self objectOrNilForKey:kMIDGOPAYResponseDeeplinkUrl fromDictionary:dict];
            self.fraudStatus = [self objectOrNilForKey:kMIDGOPAYResponseFraudStatus fromDictionary:dict];
            self.statusCode = [self objectOrNilForKey:kMIDGOPAYResponseStatusCode fromDictionary:dict];
            self.transactionTime = [self objectOrNilForKey:kMIDGOPAYResponseTransactionTime fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.finishRedirectUrl forKey:kMIDGOPAYResponseFinishRedirectUrl];
    [mutableDict setValue:self.transactionStatus forKey:kMIDGOPAYResponseTransactionStatus];
    [mutableDict setValue:self.paymentType forKey:kMIDGOPAYResponsePaymentType];
    [mutableDict setValue:self.transactionId forKey:kMIDGOPAYResponseTransactionId];
    [mutableDict setValue:self.grossAmount forKey:kMIDGOPAYResponseGrossAmount];
    [mutableDict setValue:self.orderId forKey:kMIDGOPAYResponseOrderId];
    [mutableDict setValue:self.qrCodeUrl forKey:kMIDGOPAYResponseQrCodeUrl];
    [mutableDict setValue:self.statusMessage forKey:kMIDGOPAYResponseStatusMessage];
    [mutableDict setValue:self.deeplinkUrl forKey:kMIDGOPAYResponseDeeplinkUrl];
    [mutableDict setValue:self.fraudStatus forKey:kMIDGOPAYResponseFraudStatus];
    [mutableDict setValue:self.statusCode forKey:kMIDGOPAYResponseStatusCode];
    [mutableDict setValue:self.transactionTime forKey:kMIDGOPAYResponseTransactionTime];

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

    self.finishRedirectUrl = [aDecoder decodeObjectForKey:kMIDGOPAYResponseFinishRedirectUrl];
    self.transactionStatus = [aDecoder decodeObjectForKey:kMIDGOPAYResponseTransactionStatus];
    self.paymentType = [aDecoder decodeObjectForKey:kMIDGOPAYResponsePaymentType];
    self.transactionId = [aDecoder decodeObjectForKey:kMIDGOPAYResponseTransactionId];
    self.grossAmount = [aDecoder decodeObjectForKey:kMIDGOPAYResponseGrossAmount];
    self.orderId = [aDecoder decodeObjectForKey:kMIDGOPAYResponseOrderId];
    self.qrCodeUrl = [aDecoder decodeObjectForKey:kMIDGOPAYResponseQrCodeUrl];
    self.statusMessage = [aDecoder decodeObjectForKey:kMIDGOPAYResponseStatusMessage];
    self.deeplinkUrl = [aDecoder decodeObjectForKey:kMIDGOPAYResponseDeeplinkUrl];
    self.fraudStatus = [aDecoder decodeObjectForKey:kMIDGOPAYResponseFraudStatus];
    self.statusCode = [aDecoder decodeObjectForKey:kMIDGOPAYResponseStatusCode];
    self.transactionTime = [aDecoder decodeObjectForKey:kMIDGOPAYResponseTransactionTime];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_finishRedirectUrl forKey:kMIDGOPAYResponseFinishRedirectUrl];
    [aCoder encodeObject:_transactionStatus forKey:kMIDGOPAYResponseTransactionStatus];
    [aCoder encodeObject:_paymentType forKey:kMIDGOPAYResponsePaymentType];
    [aCoder encodeObject:_transactionId forKey:kMIDGOPAYResponseTransactionId];
    [aCoder encodeObject:_grossAmount forKey:kMIDGOPAYResponseGrossAmount];
    [aCoder encodeObject:_orderId forKey:kMIDGOPAYResponseOrderId];
    [aCoder encodeObject:_qrCodeUrl forKey:kMIDGOPAYResponseQrCodeUrl];
    [aCoder encodeObject:_statusMessage forKey:kMIDGOPAYResponseStatusMessage];
    [aCoder encodeObject:_deeplinkUrl forKey:kMIDGOPAYResponseDeeplinkUrl];
    [aCoder encodeObject:_fraudStatus forKey:kMIDGOPAYResponseFraudStatus];
    [aCoder encodeObject:_statusCode forKey:kMIDGOPAYResponseStatusCode];
    [aCoder encodeObject:_transactionTime forKey:kMIDGOPAYResponseTransactionTime];
}

- (id)copyWithZone:(NSZone *)zone
{
    MIDGOPAYResponse *copy = [[MIDGOPAYResponse alloc] init];
    
    if (copy) {

        copy.finishRedirectUrl = [self.finishRedirectUrl copyWithZone:zone];
        copy.transactionStatus = [self.transactionStatus copyWithZone:zone];
        copy.paymentType = [self.paymentType copyWithZone:zone];
        copy.transactionId = [self.transactionId copyWithZone:zone];
        copy.grossAmount = [self.grossAmount copyWithZone:zone];
        copy.orderId = [self.orderId copyWithZone:zone];
        copy.qrCodeUrl = [self.qrCodeUrl copyWithZone:zone];
        copy.statusMessage = [self.statusMessage copyWithZone:zone];
        copy.deeplinkUrl = [self.deeplinkUrl copyWithZone:zone];
        copy.fraudStatus = [self.fraudStatus copyWithZone:zone];
        copy.statusCode = [self.statusCode copyWithZone:zone];
        copy.transactionTime = [self.transactionTime copyWithZone:zone];
    }
    
    return copy;
}


@end
