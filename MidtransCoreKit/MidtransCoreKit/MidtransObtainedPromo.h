//
//  MidtransObtainedPromo.h
//
//  Created by Nanang  on 2/6/17
//  Copyright (c) 2017 Zahir. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface MidtransObtainedPromo : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) id sponsorMessageEn;
@property (nonatomic, strong) NSString *promoCode;
@property (nonatomic, strong) NSString *discountToken;
@property (nonatomic, strong) NSString *sponsorName;
@property (nonatomic, strong) NSString *expiresAt;
@property (nonatomic, assign) BOOL success;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) id sponsorMessageId;
@property (nonatomic, assign) double paymentAmount;
@property (nonatomic, assign) double discountAmount;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
