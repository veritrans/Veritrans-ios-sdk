//
//  PaymentRequestTransactionDetails.h
//
//  Created by Arie  on 7/19/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface MTPaymentRequestTransactionDetails : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *orderId;
@property (nonatomic, strong) NSString *amount;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
