//
//  VTTokenizeRequest.h
//  iossdk-gojek
//
//  Created by Akbar Taufiq Herlangga on 3/10/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MidtransCreditCard.h"

/**
 `VTTokenizeRequest` is plain data object that represent a request to tokenize a credit card.
 */
@interface MTTokenizeRequest : NSObject

@property (nonatomic, readonly) MidtransCreditCard *creditCard;
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
 Get a `VTTokenizeRequest` object based on a credit card data. The resulting `VTTokenizeRequest` can be used to request token for normal credit card transaction.
 
 @param creditCard The credit card to be tokenized.
 @param grossAmount The amount to charge.
 @param secure To activate 3D secure payment.
 */
- (instancetype)initWithCreditCard:(MidtransCreditCard *)creditCard grossAmount:(NSNumber *)grossAmount secure:(BOOL)secure;

/**
 Get a `VTTokenizeReqeust` for two-clicks transaction.
 
 @param token The token from previous successful transaction.
 @param cvv The credit card's CVV.
 @param secure Flag that will be used to determine whether the token request process will use a redirect URL provided by the bank
 @param grossAmount The amount
 */
- (instancetype)initWithTwoClickToken:(NSString *)token
                                  cvv:(NSString *)cvv
                          grossAmount:(NSNumber *)grossAmount;

- (NSDictionary *)dictionaryValue;

@end
