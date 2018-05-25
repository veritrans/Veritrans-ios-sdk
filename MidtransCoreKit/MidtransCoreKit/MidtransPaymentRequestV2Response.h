//
//  MidtransPaymentRequestV2Response.h
//
//  Created by Ratna Kumalasari on 10/25/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MidtransPaymentRequestV2TransactionDetails, MidtransPaymentRequestV2CreditCard, MidtransPaymentRequestV2Merchant, MidtransPaymentRequestV2CustomerDetails, MidtransPaymentRequestV2Callbacks,MidtransTransactionExpire,MidtransPromoPromoDetails;

@interface MidtransPaymentRequestV2Response : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) MidtransPaymentRequestV2TransactionDetails *transactionDetails;
@property (nonatomic, strong) NSArray *enabledPayments;
@property (nonatomic, strong) MidtransPaymentRequestV2CreditCard *creditCard;
@property (nonatomic, strong) MidtransPaymentRequestV2Merchant *merchant;
@property (nonatomic, strong) MidtransPaymentRequestV2CustomerDetails *customerDetails;
@property (nonatomic, strong) NSArray *itemDetails;
@property (nonatomic, strong) MidtransPromoPromoDetails *promos;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) MidtransPaymentRequestV2Callbacks *callbacks;
@property (nonatomic, strong) MidtransTransactionExpire *expire;
@property (nonatomic, strong) NSDictionary *custom;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
