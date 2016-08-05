//
//  PaymentRequestResponse.h
//
//  Created by Arie  on 7/19/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PaymentRequestTransactionData, PaymentRequestMerchantData;

@interface PaymentRequestResponse : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) PaymentRequestTransactionData *transactionData;
@property (nonatomic, strong) PaymentRequestMerchantData *merchantData;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
