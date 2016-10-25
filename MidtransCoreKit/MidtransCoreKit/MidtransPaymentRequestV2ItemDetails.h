//
//  MidtransPaymentRequestV2ItemDetails.h
//
//  Created by Ratna Kumalasari on 10/25/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface MidtransPaymentRequestV2ItemDetails : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double quantity;
@property (nonatomic, strong) NSString *itemDetailsIdentifier;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) double price;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
