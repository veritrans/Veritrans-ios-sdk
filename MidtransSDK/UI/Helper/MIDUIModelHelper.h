//
//  MIDModelHelper.h
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 05/03/19.
//  Copyright © 2019 Midtrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MidtransSDK.h"
#import "MIDCreditCardModel.h"

@interface MIDUIModelHelper : NSObject
@end

@interface MIDPaymentResult (utils)
- (NSString *)codeForLocalization;
@end

@interface NSString (CreditCard)
- (BOOL)isNumeric;
- (BOOL)isValidCVVWithCreditCardNumber:(NSString *)cardNumber error:(NSError **)error;
- (BOOL)isValidYearExpiryDate:(NSError **)error;
- (BOOL)isValidMonthExpiryDate:(NSError **)error;
- (BOOL)isValidExpiryDate:(NSError **)error;
- (BOOL)isValidValue:(NSError **)error;
- (BOOL)isValidCreditCardNumber:(NSError **)error;
@end
