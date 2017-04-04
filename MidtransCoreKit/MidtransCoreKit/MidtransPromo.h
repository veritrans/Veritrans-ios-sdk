//
//  MidtransPromo.h
//
//  Created by Nanang  on 2/6/17
//  Copyright (c) 2017 Zahir. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface MidtransPromo : NSObject <NSCoding, NSCopying>

@property (nonatomic) id sponsorMessageEn;
@property (nonatomic, strong) NSString *promoCode;
@property (nonatomic, strong) NSString *discountType;
@property (nonatomic, assign) double promoIdentifier;
@property (nonatomic, strong) NSString *sponsorName;
@property (nonatomic, strong) NSArray *bins;
@property (nonatomic, strong) NSString *startDate;
@property (nonatomic) id sponsorMessageId;
@property (nonatomic, assign) double discountAmount;
@property (nonatomic, strong) NSString *endDate;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
