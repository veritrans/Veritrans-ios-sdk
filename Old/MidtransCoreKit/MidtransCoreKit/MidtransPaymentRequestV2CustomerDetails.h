//
//  MidtransPaymentRequestV2CustomerDetails.h
//
//  Created by Ratna Kumalasari on 10/25/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MidtransPaymentRequestV2ShippingAddress, MidtransPaymentRequestV2BillingAddress;

@interface MidtransPaymentRequestV2CustomerDetails : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) MidtransPaymentRequestV2ShippingAddress *shippingAddress;
@property (nonatomic, strong) MidtransPaymentRequestV2BillingAddress *billingAddress;
@property (nonatomic, strong) NSString *firstName;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
