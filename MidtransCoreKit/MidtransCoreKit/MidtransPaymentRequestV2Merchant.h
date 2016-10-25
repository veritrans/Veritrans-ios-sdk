//
//  MidtransPaymentRequestV2Merchant.h
//
//  Created by Ratna Kumalasari on 10/25/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MidtransPaymentRequestV2Preference;

@interface MidtransPaymentRequestV2Merchant : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *clientKey;
@property (nonatomic, strong) NSArray *enabledPrinciples;
@property (nonatomic, strong) MidtransPaymentRequestV2Preference *preference;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
