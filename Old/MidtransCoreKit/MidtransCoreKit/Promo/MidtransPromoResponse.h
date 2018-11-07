//
//  MidtransPromoResponse.h
//
//  Created by Ratna Kumalasari on 3/28/18
//  Copyright (c) 2018 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MidtransPromoPromoDetails;

@interface MidtransPromoResponse : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) MidtransPromoPromoDetails *promoDetails;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
