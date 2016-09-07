//
//  Snapresponse.h
//
//  Created by Arie  on 7/19/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VTItemDetail.h"
#import "VTTransactionDetails.h"
#import "VTCustomerDetails.h"

@interface MTTransactionTokenResponse : NSObject <NSCoding, NSCopying>
@property (nonatomic, strong) NSString *tokenId;
@property (nonatomic, strong) VTTransactionDetails *transactionDetails;
@property (nonatomic, strong) VTCustomerDetails *customerDetails;
@property (nonatomic, strong) NSArray <VTItemDetail *>*itemDetails;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict transactionDetails:(VTTransactionDetails *)transactionDetails customerDetails:(VTCustomerDetails *)customerDetails itemDetails:(NSArray <VTItemDetail*>*)itemDetails;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
