//
//  VTPaymentCreditCard.h
//  iossdk-gojek
//
//  Created by Akbar Taufiq Herlangga on 3/10/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MidtransPaymentDetails.h"
#import "MTCreditCardPaymentFeature.h"

/**
 `VTPaymentCreditCard` contains all the data needed to perform transaction againts Veritrans Server using credit card.
 
 This class is modeled after http://docs.veritrans.co.id/en/api/methods.html#credit_card_attr
 */
@interface MTPaymentCreditCard : NSObject <MidtransPaymentDetails>

/**
 The name of the bank.
 */
@property (nonatomic) NSString *_Nullable bank;

/**
 The monthly term of the payment.
 */
@property (nonatomic) NSNumber *_Nullable installmentTerm;

/**
 List of credit card's BIN (Bank Identification Number) that is allowed for transaction.
 All BIN can have 1 to 8 digits.
 */
@property (nonatomic) NSArray *_Nullable bins;

/**
 The feature to be used during pre-authorization. Valid value: "authorize".
 */
@property (nonatomic) NSString *_Nullable type;

/**
 Flag to determine whether Veritrans server should keep record of this payment attribute to used in future transaction. To use `one-click` and `two-clicks` feature, this feature must be enabled.
 */
@property (nonatomic) BOOL saveToken;


///--------------------
/// @name Instantiation
///--------------------

/**
 Returns an instance of `VTPaymentCreditCard` for specified token ID. The token ID can be generated using `VTClient generateToken:completion:`.
 
 @param feature The feature of the payment.
 @param tokenId The specified token ID.
 */
- (instancetype _Nonnull)initWithFeature:(MTCreditCardPaymentFeature)feature
                         creditCardToken:(NSString *_Nonnull)creditCardToken
                                   token:(MidtransTransactionTokenResponse *_Nonnull)token;

- (instancetype _Nonnull)initWithCreditCardToken:(NSString *_Nonnull)creditCardToken
                                           token:(MidtransTransactionTokenResponse *_Nonnull)token;

@end
