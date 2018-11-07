//
//  SNPPointResponse.h
//
//  Created by Zanna Simarmata on 3/7/17
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface SNPPointResponse : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSArray *validationMessages;
@property (nonatomic, assign) double pointBalance;
@property (nonatomic, strong) NSString *statusMessage;
@property (nonatomic, strong) NSString *statusCode;
@property (nonatomic, strong) NSString *transactionTime;
@property (nonatomic, strong) NSString *pointBalanceAmount;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
