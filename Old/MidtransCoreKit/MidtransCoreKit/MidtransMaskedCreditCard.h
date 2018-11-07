//
//  MTMaskedCreditCard.h
//  iossdk-gojek
//
//  Created by Nanang Rafsanjani on 3/10/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * _Nonnull const kMTMaskedCreditCardIdentifier = @"token_id";
static NSString * _Nonnull const kMTMaskedCreditCardCardhash = @"cardhash";
static NSString * _Nonnull const kMTMaskedCreditCardType = @"type";
static NSString * _Nonnull const kMTMaskedCreditCardTokenType = @"token_type";
static NSString * _Nonnull const kMTMaskedCreditCardExpiresAt = @"expires_at";

/**
 Object that represent partially saved credit card information.
 */
@interface MidtransMaskedCreditCard : NSObject

/**
 Partial number of the credit card.
 */
@property (nonatomic, readonly, nonnull) NSString *maskedNumber;

/**
 The Token ID that represent saved credit card stored in the Merchant Server.
 */
@property (nonatomic, readonly, nonnull) NSString *savedTokenId;

@property (nonatomic, readonly, nullable) NSString *type;

@property (nonatomic, readonly, nullable) NSString *tokenType;
@property (nonatomic, readonly, nullable) NSString *statusCode;
@property (nonatomic, readonly, nullable) NSString *transactionId;

@property (nonatomic, readonly, nullable) NSString *expiresAt;

@property (nonatomic, readonly, nullable) NSDictionary *dictionaryValue;

- (instancetype _Nonnull)initWithDictionary:(NSDictionary *_Nonnull)dictionary;

- (instancetype _Nonnull)initWithData:(NSDictionary *_Nonnull)data;
- (instancetype _Nonnull)initWithSavedTokenId:(NSString * _Nonnull)savedTokenId
                         maskedNumber:(NSString * _Nonnull)maskedNumber
                            tokenType:(NSString * _Nullable)tokenType
                            expiresAt:(NSString *_Nullable)expiresAt;

/*
 self.savedTokenId = dictionary[kMTMaskedCreditCardIdentifier];
 self.maskedNumber = dictionary[kMTMaskedCreditCardCardhash];
 self.type = dictionary[kMTMaskedCreditCardType]?dictionary[kMTMaskedCreditCardType]:@"";
 self.tokenType = dictionary[kMTMaskedCreditCardTokenType]?dictionary[kMTMaskedCreditCardTokenType]:@"";
 self.expiresAt = dictionary[kMTMaskedCreditCardExpiresAt]?dictionary[kMTMaskedCreditCardExpiresAt]:@"";
 self.statusCode = @"";
 self.transactionId = @"";
 */
@end
