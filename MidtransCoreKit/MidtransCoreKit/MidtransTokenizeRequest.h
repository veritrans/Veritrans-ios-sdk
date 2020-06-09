//
//  MidtransTokenizeRequest.h
//  iossdk-gojek
//
//  Created by Akbar Taufiq Herlangga on 3/10/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MidtransCreditCard.h"
#import "MidtransObtainedPromo.h"
#import "MidtransCreditCardConfig.h"
/**
 `MidtransTokenizeRequest` is plain data object that represent a request to tokenize a credit card.
 */
@interface MidtransTokenizeRequest : NSObject

@property (nonatomic) MidtransCreditCard *creditCard;
@property (nonatomic) NSNumber *grossAmount;
@property (nonatomic) BOOL installment;
@property (nonatomic) BOOL point;
@property (nonatomic) NSDictionary *promos;
@property (nonatomic) NSNumber *installmentTerm;
@property (nonatomic) NSString *token;
@property (nonatomic) BOOL twoClick;
@property (nonatomic) BOOL secure;


///----------------
/// @Initialization
///----------------

/**
 Get a `MidtransTokenizeRequest` object based on a credit card data. The resulting `MidtransTokenizeRequest` can be used to request token for normal credit card transaction.
 
 @param creditCard The credit card to be tokenized.
 @param grossAmount The amount to charge.
 */
- (instancetype)initWithCreditCard:(MidtransCreditCard *)creditCard
                       grossAmount:(NSNumber *)grossAmount;
- (instancetype)initWithCreditCard:(MidtransCreditCard *)creditCard;
- (instancetype)initWithTwoClickToken:(NSString *)token
                                  cvv:(NSString *)cvv
                          grossAmount:(NSNumber *)grossAmount
                          installment:(BOOL)installment
                      installmentTerm:(NSNumber *)installmentTerm;

- (instancetype)initWithCreditCard:(MidtransCreditCard *)creditCard
                       grossAmount:(NSNumber *)grossAmount
                       installment:(BOOL)installment
                   installmentTerm:(NSNumber *)installmentTerm;

- (instancetype)initWithCreditCardToken:(NSString *)token
                                    cvv:(NSString *)cvv
                            grossAmount:(NSNumber *)grossAmount
                                 secure:(BOOL)secure
                       paymentTokenType:(MTCreditCardPaymentType)paymentTokenType;
/**
 Get a `VTTokenizeReqeust` for two-clicks transaction.
 
 @param token The token from previous successful transaction.
 @param cvv The credit card's CVV.
 @param grossAmount The amount
 */
- (instancetype)initWithTwoClickToken:(NSString *)token
                                  cvv:(NSString *)cvv
                          grossAmount:(NSNumber *)grossAmount;

- (NSDictionary *)dictionaryValue;

@end
