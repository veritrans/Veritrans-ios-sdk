//
//  MidtransPromoPromoDetails.h
//
//  Created by Ratna Kumalasari on 3/28/18
//  Copyright (c) 2018 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MidtransPromoPromos.h"



@interface MidtransPromoPromoDetails : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSArray <MidtransPromoPromos *>*promos;
;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
