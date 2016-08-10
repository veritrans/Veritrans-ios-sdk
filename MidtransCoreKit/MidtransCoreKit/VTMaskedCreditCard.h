//
//  VTMaskedCreditCard.h
//  iossdk-gojek
//
//  Created by Nanang Rafsanjani on 3/10/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Object that represent partially saved credit card information.
 */
@interface VTMaskedCreditCard : NSObject

/**
 Partial number of the credit card.
 */
@property (nonatomic, readonly, nonnull) NSString *maskedNumber;

/**
 The Token ID that represent saved credit card stored in the Merchant Server.
 */
@property (nonatomic, readonly, nonnull) NSString *savedTokenId;

@property (nonatomic, readonly, nonnull) NSString *type;

@property (nonatomic, readonly, nullable) NSDictionary *dictionaryValue;

- (instancetype _Nonnull)initWithDictionary:(NSDictionary *_Nonnull)dictionary;

- (instancetype _Nonnull)initWithData:(NSDictionary *_Nonnull)data;

@end
