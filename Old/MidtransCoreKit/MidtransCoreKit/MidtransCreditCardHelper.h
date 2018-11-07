//
//  MIdtransCreditCardHelper.h
//  iossdk-gojek
//
//  Created by Akbar Taufiq Herlangga on 3/23/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MidtransCreditCard.h"

static NSString * const ExpiryDateSeparator = @" / ";

typedef NS_ENUM(NSInteger, MidtransCreditCardType) {
    VTCreditCardTypeVisa,
    VTCreditCardTypeMasterCard,
    VTCreditCardTypeJCB,
    VTCreditCardTypeAmex,
    VTCreditCardTypeUnknown
};

@interface NSString (CreditCard)
- (BOOL)isValidCVVWithCreditCardNumber:(NSString *)cardNumber error:(NSError **)error;
- (BOOL)isValidExpiryDate:(NSError **)error;
- (BOOL)isValidValue:(NSError **)error;//// just for gift card
- (BOOL)isValidCreditCardNumber:(NSError **)error;
@end

@interface MidtransCreditCardHelper : NSObject
+ (MidtransCreditCardType)typeFromString:(NSString *)string;
+ (NSString *)nameFromString:(NSString *)string;
@end

@interface MidtransCreditCard (Validation)
- (BOOL)isValidCreditCard:(NSError **)error;
@end

@interface UITextField (helper)

- (BOOL)filterNumericWithString:(NSString *)string range:(NSRange)range length:(NSInteger)length;
- (BOOL)filterCvvNumber:(NSString *)string range:(NSRange)range withCardNumber:(NSString *)cardNumber;
- (BOOL)filterCreditCardExpiryDate:(NSString *)string range:(NSRange)range;

@end
