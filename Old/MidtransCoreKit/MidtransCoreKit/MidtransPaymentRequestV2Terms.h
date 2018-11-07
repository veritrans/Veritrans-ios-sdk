//
//  MidtransPaymentRequestV2Terms.h
//
//  Created by Zanna Simarmata on 1/3/17
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface MidtransPaymentRequestV2Terms : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSArray *mandiri;
@property (nonatomic, strong) NSArray *bni;
@property (nonatomic, strong) NSArray *bca;
@property (nonatomic, strong) NSArray *offline;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
