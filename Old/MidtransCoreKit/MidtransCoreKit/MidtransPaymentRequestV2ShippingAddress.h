//
//  MidtransPaymentRequestV2ShippingAddress.h
//
//  Created by Ratna Kumalasari on 10/25/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface MidtransPaymentRequestV2ShippingAddress : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *countryCode;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *postalCode;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
