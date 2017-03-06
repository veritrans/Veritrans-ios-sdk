//
//  MidtransPaymentRequestV2Installment2.h
//
//  Created by Zanna Simarmata on 1/3/17
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MidtransPaymentRequestV2Installment;

@interface MidtransPaymentRequestV2Installment2 : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) MidtransPaymentRequestV2Installment *installment;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
