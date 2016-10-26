//
//  MidtransPaymentRequestV2SavedTokens.h
//
//  Created by Ratna Kumalasari on 10/25/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface MidtransPaymentRequestV2SavedTokens : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *tokenType;
@property (nonatomic, strong) NSString *expiresAt;
@property (nonatomic, strong) NSString *maskedCard;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
