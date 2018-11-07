//
//  VTPaymentCreditCard.h
//  iossdk-gojek
//
//  Created by Akbar Taufiq Herlangga on 3/10/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MidtransPaymentDetails.h"

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
@property (nonatomic) NSDictionary *_Nullable promos;

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

+ (instancetype _Nonnull)modelWithToken:(NSString *_Nonnull)token
                               customer:(MidtransCustomerDetails *_Nonnull)customer
                               saveCard:(BOOL)saveCard
                            installment:(NSString *_Nullable)installment;

+ (instancetype _Nonnull)modelWithToken:(NSString *_Nonnull)token
                               customer:(MidtransCustomerDetails *_Nonnull)customer
                               saveCard:(BOOL)saveCard
                                  point:(NSString *_Nullable)point;

+ (instancetype _Nonnull)modelWithMaskedCard:(NSString *_Nonnull)maskedCard
                                    customer:(MidtransCustomerDetails *_Nonnull)customer
                                    saveCard:(BOOL)saveCard
                                 installment:(NSString *_Nullable)installment;

+ (instancetype _Nonnull)modelWithToken:(NSString *_Nonnull)token
                               customer:(MidtransCustomerDetails *_Nonnull)customer
                               saveCard:(BOOL)saveCard
                            installment:(NSString *_Nullable)installment
                                 promos:(NSDictionary *_Nullable)promos;
@end
