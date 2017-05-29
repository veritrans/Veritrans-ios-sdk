//
//  SNPFreeTextPayment.h
//
//  Created by Ratna Kumalasari on 5/25/17
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface SNPFreeTextPayment : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *paymentIdentifier;
@property (nonatomic, strong) NSString *en;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
