//
//  MIDCreditCardHelper.h
//  iossdk-gojek
//
//  Created by Akbar Taufiq Herlangga on 3/23/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MIDCreditCardModel.h"

static NSString * const ExpiryDateSeparator = @" / ";

typedef NS_ENUM(NSInteger, MIDCreditCardType) {
    MIDCreditCardTypeVisa,
    MIDCreditCardTypeMasterCard,
    MIDCreditCardTypeJCB,
    MIDCreditCardTypeAmex,
    MIDCreditCardTypeUnknown
};

@interface NSString (CreditCard)
- (BOOL)isValidCVVWithCreditCardNumber:(NSString *)cardNumber error:(NSError **)error;
- (BOOL)isValidExpiryDate:(NSError **)error;
- (BOOL)isValidValue:(NSError **)error;//// just for gift card
- (BOOL)isValidCreditCardNumber:(NSError **)error;
@end

@interface MIDCreditCardHelper : NSObject
+ (MIDCreditCardType)typeFromString:(NSString *)string;
+ (NSString *)nameFromString:(NSString *)string;

+ (BOOL)isCreditCardNumber:(NSString *_Nonnull)ccNumber eligibleForPromo:(NSArray *_Nonnull)bins error:(NSError *_Nullable*_Nullable)error;
+ (BOOL)isCreditCardNumber:(NSString *_Nonnull)ccNumber containBlacklistBins:(NSArray *_Nonnull)bins error:(NSError *_Nullable*_Nullable)error;
+ (BOOL)isCreditCardNumber:(NSString *)ccNumber eligibleForBins:(NSArray *)bins error:(NSError **)error;
@end

@interface MIDCreditCardModel (Validation)
- (BOOL)isValidCreditCard:(NSError **)error;
@end

@interface UITextField (helper)

- (BOOL)filterNumericWithString:(NSString *)string range:(NSRange)range length:(NSInteger)length;
- (BOOL)filterCvvNumber:(NSString *)string range:(NSRange)range withCardNumber:(NSString *)cardNumber;
- (BOOL)filterCreditCardExpiryDate:(NSString *)string range:(NSRange)range;

@end
