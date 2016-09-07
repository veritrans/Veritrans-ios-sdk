//
//  PaymentRequestResponse.h
//
//  Created by Arie  on 7/19/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MTPaymentRequestTransactionData, MTPaymentRequestMerchantData;

@interface MTPaymentRequestResponse : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) MTPaymentRequestTransactionData *transactionData;
@property (nonatomic, strong) MTPaymentRequestMerchantData *merchantData;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
