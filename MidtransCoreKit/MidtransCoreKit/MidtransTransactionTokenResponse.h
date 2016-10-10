//
//  Snapresponse.h
//
//  Created by Arie  on 7/19/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MidtransItemDetail.h"
#import "MidtransTransactionDetails.h"
#import "MidtransCustomerDetails.h"

@interface MidtransTransactionTokenResponse : NSObject <NSCoding, NSCopying>
@property (nonatomic, strong) NSString *tokenId;
@property (nonatomic, strong) MidtransTransactionDetails *transactionDetails;
@property (nonatomic, strong) MidtransCustomerDetails *customerDetails;
@property (nonatomic, strong) NSArray <MidtransItemDetail *>*itemDetails;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict transactionDetails:(MidtransTransactionDetails *)transactionDetails customerDetails:(MidtransCustomerDetails *)customerDetails itemDetails:(NSArray <MidtransItemDetail*>*)itemDetails;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
