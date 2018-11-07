//
//  MidtransPaymentRequestV2SavedTokens.h
//
//  Created by Ratna Kumalasari on 10/25/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const TokenTypeTwoClicks = @"two_clicks";
static NSString *const TokenTypeOneClick = @"one_click";

@interface MidtransPaymentRequestV2SavedTokens : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *tokenType;
@property (nonatomic, strong) NSString *expiresAt;
@property (nonatomic, strong) NSString *maskedCard;
@property (nonatomic, strong) NSString *token;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
