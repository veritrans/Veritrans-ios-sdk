//
//  PaymentRequestResponse.h
//
//  Created by Arie  on 7/19/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MidtransPaymentRequestTransactionData, MidtransPaymentRequestMerchantData;

@interface MidtransPaymentRequestResponse : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) MidtransPaymentRequestTransactionData *transactionData;
@property (nonatomic, strong) MidtransPaymentRequestMerchantData *merchantData;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
