//
//  Snapresponse.h
//
//  Created by Arie  on 7/19/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTItemDetail.h"
#import "VTTransactionDetails.h"
#import "MTCustomerDetails.h"

@interface MTTransactionTokenResponse : NSObject <NSCoding, NSCopying>
@property (nonatomic, strong) NSString *tokenId;
@property (nonatomic, strong) VTTransactionDetails *transactionDetails;
@property (nonatomic, strong) MTCustomerDetails *customerDetails;
@property (nonatomic, strong) NSArray <MTItemDetail *>*itemDetails;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict transactionDetails:(VTTransactionDetails *)transactionDetails customerDetails:(MTCustomerDetails *)customerDetails itemDetails:(NSArray <MTItemDetail*>*)itemDetails;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
