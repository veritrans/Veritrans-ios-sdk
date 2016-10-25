//
//  MidtransPaymentRequestV2CreditCard.h
//
//  Created by Ratna Kumalasari on 10/25/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface MidtransPaymentRequestV2CreditCard : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) BOOL secure;
@property (nonatomic, strong) NSArray *whitelistBins;
@property (nonatomic, assign) BOOL saveCard;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
