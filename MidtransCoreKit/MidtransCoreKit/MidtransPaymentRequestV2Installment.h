//
//  Installment.h
//
//  Created by Ratna Kumalasari on 11/23/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MidtransPaymentRequestV2Installment : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSDictionary *terms;
@property (nonatomic, assign) BOOL required;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
