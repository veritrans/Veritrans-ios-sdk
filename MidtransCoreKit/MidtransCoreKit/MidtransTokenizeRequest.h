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

/**
 `MidtransTokenizeRequest` is plain data object that represent a request to tokenize a credit card.
 */
@interface MidtransTokenizeRequest : NSObject

@property (nonatomic) MidtransCreditCard *creditCard;
@property (nonatomic) NSNumber *grossAmount;
@property (nonatomic) BOOL installment;
@property (nonatomic) BOOL point;
@property (nonatomic) NSNumber *installmentTerm;
@property (nonatomic) NSString *token;
@property (nonatomic) BOOL twoClick;
@property (nonatomic) BOOL secure;

@property (nonatomic) MidtransObtainedPromo *obtainedPromo;

///----------------
/// @Initialization
///----------------

/**
 Get a `MidtransTokenizeRequest` object based on a credit card data. The resulting `MidtransTokenizeRequest` can be used to request token for normal credit card transaction.
 
 @param creditCard The credit card to be tokenized.
 @param grossAmount The amount to charge.
 @param secure To activate 3D secure payment.
 */
- (instancetype)initWithCreditCard:(MidtransCreditCard *)creditCard
                       grossAmount:(NSNumber *)grossAmount
                            secure:(BOOL)secure;

- (instancetype)initWithTwoClickToken:(NSString *)token
                                  cvv:(NSString *)cvv
                          grossAmount:(NSNumber *)grossAmount
                          installment:(BOOL)installment
                      installmentTerm:(NSNumber *)installmentTerm;

- (instancetype)initWithCreditCard:(MidtransCreditCard *)creditCard
                       grossAmount:(NSNumber *)grossAmount
                       installment:(BOOL)installment
                   installmentTerm:(NSNumber *)installmentTerm
                            secure:(BOOL)secure;

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
