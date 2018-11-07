//
//  MidtransPaymentRequestV2Installment.h
//
//  Created by Zanna Simarmata on 1/3/17
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MidtransPaymentRequestV2Installment : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSDictionary *terms;
@property (nonatomic, assign) BOOL required;

+ (instancetype)modelWithTerms:(NSDictionary *)terms isRequired:(BOOL)required;
+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
