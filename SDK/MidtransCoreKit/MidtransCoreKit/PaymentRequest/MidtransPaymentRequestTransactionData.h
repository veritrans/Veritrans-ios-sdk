//
//  PaymentRequestTransactionData.h
//
//  Created by Arie  on 7/19/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MidtransPaymentRequestCustomerDetails, MidtransPaymentRequestTransactionDetails, MidtransPaymentRequestPaymentOptions, MidtransPaymentRequestBankTransfer;

@interface MidtransPaymentRequestTransactionData : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSArray *enabledPayments;
@property (nonatomic, strong) NSArray *itemDetails;
@property (nonatomic, strong) MidtransPaymentRequestCustomerDetails *customerDetails;
@property (nonatomic, strong) NSString *transactionDataIdentifier;
@property (nonatomic, strong) MidtransPaymentRequestTransactionDetails *transactionDetails;
@property (nonatomic, strong) MidtransPaymentRequestPaymentOptions *paymentOptions;
@property (nonatomic, strong) NSString *transactionId;
@property (nonatomic, strong) NSString *kind;
@property (nonatomic, strong) MidtransPaymentRequestBankTransfer *bankTransfer;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
