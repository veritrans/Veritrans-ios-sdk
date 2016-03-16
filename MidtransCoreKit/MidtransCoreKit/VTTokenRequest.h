//
//  VTTokenRequest.h
//  MidtransCoreKit
//
//  Created by Akbar Taufiq Herlangga on 3/10/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VTCreditCard.h"

/**
 `VTTokenRequest` is plain data object that represent a request to tokenize a credit card.
 */
@interface VTTokenRequest : NSObject

@property (nonatomic, readonly) VTCreditCard *creditCard;
@property (nonatomic, readonly) NSString *bank;
@property (nonatomic, readonly) NSNumber *grossAmount;
@property (nonatomic, readonly) BOOL installment;
@property (nonatomic, readonly) NSNumber *installmentTerm;
@property (nonatomic, readonly) NSString *token;
@property (nonatomic, readonly) BOOL twoClick;
@property (nonatomic, readonly) NSString *type;
@property (nonatomic, readonly) BOOL secure;

///----------------
/// @Initialization
///----------------

/**
 Get a `VTTokenRequest` object based on a credit card data. The returned `VTTokenRequest` can be used to reqeust token for normal credit card transaction.
 
 @param creditCard The credit card to be tokenized.
 */
+ (instancetype)tokenForNormalTransactionWithCreditCard:(VTCreditCard *)creditCard;

/**
 Get a `VTTokenReqeust` for two-clicks transaction.
 
 @param token The token from TODO.
 @param cvv The credit card's CVV.
 @param secure Flag that will be used to determine whether the token request process will use a redirect URL provided by the bank
 @param grossAmount The amount
 */
+ (instancetype)tokenForTwoClickTransactionWithToken:(NSString *)token
                                                 cvv:(NSString *)cvv
                                              secure:(BOOL)secure
                                         grossAmount:(NSNumber *)grossAmount;

- (NSDictionary *)dictionaryValue;

@end
