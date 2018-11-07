//
//  MidtransPromoPromos.h
//
//  Created by Ratna Kumalasari on 3/28/18
//  Copyright (c) 2018 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface MidtransPromoPromos : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSArray *bins;
@property (nonatomic, strong) NSString *discountType;
@property (nonatomic, assign) double promosIdentifier;
@property (nonatomic, assign) double discountedGrossAmount;
@property (nonatomic, assign) double calculatedDiscountAmount;
@property (nonatomic, strong) NSArray *paymentTypes;
@property (nonatomic, strong) NSString *name;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
