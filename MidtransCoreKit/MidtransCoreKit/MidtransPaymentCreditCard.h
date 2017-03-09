//
//  VTPaymentCreditCard.h
//  iossdk-gojek
//
//  Created by Akbar Taufiq Herlangga on 3/10/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MidtransPaymentDetails.h"
#import "MidtransCreditCardPaymentFeature.h"

/**
 `VTPaymentCreditCard` contains all the data needed to perform transaction againts Veritrans Server using credit card.
 
 This class is modeled after http://docs.veritrans.co.id/en/api/methods.html#credit_card_attr
 */
@interface MidtransPaymentCreditCard : NSObject <MidtransPaymentDetails>

/**
 The name of the bank.
 */
@property (nonatomic) NSString *_Nullable bank;


@property (nonatomic,strong) NSString *_Nullable installmentTerm;
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

/*
 Token to include promo to the credit card transaction
 */
@property (nonatomic, nullable) NSString *discountToken;

///--------------------
/// @name Instantiation
///--------------------

+ (instancetype)modelWithToken:(NSString *)token customer:(MidtransCustomerDetails *)customer saveCard:(BOOL)saveCard installment:(NSString *)installment;
+ (instancetype)modelWithToken:(NSString *)token customer:(MidtransCustomerDetails *)customer saveCard:(BOOL)saveCard point:(NSString *)point;

+ (instancetype)modelWithMaskedCard:(NSString *)maskedCard customer:(MidtransCustomerDetails *)customer saveCard:(BOOL)saveCard installment:(NSString *)installment;
@end
