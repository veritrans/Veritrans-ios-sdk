//
//  MidtransPaymentRequestV2CreditCard.h
//
//  Created by Ratna Kumalasari on 10/25/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@class MidtransPaymentRequestV2Installment;
@interface MidtransPaymentRequestV2CreditCard : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSArray *savedTokens;
@property (nonatomic, strong) NSArray *whitelistBins;
@property (nonatomic, strong) NSArray *blacklistBins;
@property (nonatomic, strong) MidtransPaymentRequestV2Installment *installments;
@property (nonatomic, assign) BOOL saveCard;
@property (nonatomic, assign) BOOL secure;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
