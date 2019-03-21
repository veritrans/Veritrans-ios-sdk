//
//  MIDCreditCardHelper.m
//  iossdk-gojek
//
//  Created by Akbar Taufiq Herlangga on 3/23/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MIDCreditCardHelper.h"
#import "MIDLuhn.h"
#import "MidtransHelper.h"
#import "MIDConstants.h"
#import "NSString+MidtransValidation.h"

@implementation NSString (CreditCard)

- (BOOL)isNumeric {
    NSString *numericRegex = @"^[0-9]*$";
    NSPredicate *myTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numericRegex];
    return [myTest evaluateWithObject:self];
}

- (BOOL)isValidCVVWithCreditCardNumber:(NSString *)cardNumber error:(NSError **)error {
    BOOL valid = [self isNumeric] && [self length] <= 6 && [self length] >= 3;
    
    if (valid) {
        return YES;
    } else {
        NSString *errorMessage = NSLocalizedString(MIDTRANS_MESSAGE_CARD_CVV_INVALID, nil);
        *error = [NSError errorWithDomain:MIDTRANS_ERROR_DOMAIN code:MIDTRANS_ERROR_CODE_INVALIDCVV userInfo:@{NSLocalizedDescriptionKey:errorMessage}];
        return NO;
    }
}

- (BOOL)isValidYearExpiryDate:(NSError **)error {
    BOOL formatValid = false;
    NSString *expYear = self;
    if (([expYear length] == 2) || ([expYear length] == 4)){
        if (([expYear length] == 4)) {
            expYear = [NSString stringWithFormat:@"%ld",[expYear integerValue] - 2000];
        }
        formatValid = true;
    }
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yy";
    NSInteger currentYear = [[df stringFromDate:[NSDate date]] integerValue];
    
    
    BOOL yearExpired = [expYear integerValue] < currentYear;
    BOOL yearGreaterThan10 = (currentYear+10) < [expYear integerValue];
    
    if (formatValid && !yearExpired && !yearGreaterThan10) {
        return YES;
    }
    else {
        NSString *errorMessage = NSLocalizedString(MIDTRANS_MESSAGE_EXPIRE_DATE_INVALID, nil);
        *error = [NSError errorWithDomain:MIDTRANS_ERROR_DOMAIN code:MIDTRANS_ERROR_CODE_INVALID_EXPIRY_DATE userInfo:@{NSLocalizedDescriptionKey:errorMessage}];
        return NO;
    }
}

- (BOOL)isValidMonthExpiryDate:(NSError **)error {
    BOOL valid = ([self length] == 2) || ([self length] == 4);
    if (valid) {
        return YES;
    } else {
        NSString *errorMessage = NSLocalizedString(MIDTRANS_MESSAGE_EXPIRE_MONTH_INVALID, nil);
        *error = [NSError errorWithDomain:MIDTRANS_ERROR_DOMAIN code:MIDTRANS_ERROR_CODE_INVALID_EXPIRY_DATE userInfo:@{NSLocalizedDescriptionKey:errorMessage}];
        return NO;
    }
}

- (BOOL)isValidExpiryDate:(NSError **)error {
    NSArray *dates = [self componentsSeparatedByString:ExpiryDateSeparator];
    NSString *expMonth = dates[0];
    NSString *expYear = dates.count == 2 ? dates[1] : @"";
    
    if ([expMonth isValidMonthExpiryDate:error] == NO) {
        return NO;
    } else if ([expYear isValidYearExpiryDate:error] == NO) {
        return NO;
    } else {
        return YES;
    }
}
- (BOOL)isValidValue:(NSError **)error {
    if (!self.SNPisEmpty) {
        return YES;
    } else {
        NSString *errorMessage = NSLocalizedString(MIDTRANS_MESSAGE_INPUT_VALUE_INVALID, nil);
        *error = [NSError errorWithDomain:MIDTRANS_ERROR_DOMAIN code:MIDTRANS_ERROR_CODE_INVALID_VALUE userInfo:@{NSLocalizedDescriptionKey:errorMessage}];
        return NO;
    }
}
- (BOOL)isValidCreditCardNumber:(NSError **)error {
    if ([MIDLuhn validateString:self]) {
        return YES;
    } else {
        NSString *errorMessage = NSLocalizedString(MIDTRANS_MESSAGE_CARD_INVALID, nil);
        *error = [NSError errorWithDomain:MIDTRANS_ERROR_DOMAIN code:MIDTRANS_ERROR_CODE_INVALID_CC_NUMBER userInfo:@{NSLocalizedDescriptionKey:errorMessage}];
        return NO;
    }
}

@end

@implementation MIDCreditCardModel (Validation)

- (BOOL)isValidCreditCard:(NSError **)error {
    if ([self.number isValidCreditCardNumber:error] == NO) {
        return NO;
    }
    
    if ([self.expiryYear isValidYearExpiryDate:error] == NO) {
        return NO;
    }
    
    if ([self.expiryMonth isValidMonthExpiryDate:error] == NO) {
        return NO;
    }
    
    if ([self.cvv isValidCVVWithCreditCardNumber:self.number error:error] == NO) {
        return NO;
    }
    
    return YES;
}

@end

@implementation MIDCreditCardHelper

+ (MIDCreditCardType)typeFromString:(NSString *)string {
    NSString *formattedString = [string formattedStringForProcessing];
    NSArray *enums = @[@(MIDCreditCardTypeVisa), @(MIDCreditCardTypeMasterCard), @(MIDCreditCardTypeJCB), @(MIDCreditCardTypeAmex)];
    
    __block MIDCreditCardType type = MIDCreditCardTypeUnknown;
    [enums enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        MIDCreditCardType _type = [obj integerValue];
        NSPredicate *predicate = [MIDCreditCardHelper predicateForType:_type];
        BOOL isCurrentType = [predicate evaluateWithObject:formattedString];
        if (isCurrentType) {
            type = _type;
            *stop = YES;
        }
    }];
    return type;
}

+ (NSString *)nameFromString:(NSString *)string {
    switch ([self typeFromString:string]) {
        case MIDCreditCardTypeAmex:
            return CREDIT_CARD_TYPE_AMEX;
        case MIDCreditCardTypeJCB:
            return CREDIT_CARD_TYPE_JCB;
        case MIDCreditCardTypeMasterCard:
            return CREDIT_CARD_TYPE_MASTER_CARD;
        case MIDCreditCardTypeVisa:
            return CREDIT_CARD_TYPE_VISA;
        default:
            return @"";
    }
}

+ (NSPredicate *)predicateForType:(MIDCreditCardType)type {
    NSString *regex = nil;
    switch (type) {
        case MIDCreditCardTypeAmex:
            regex = MIDTRANS_AMEX_REGEX;
            break;
        case MIDCreditCardTypeJCB:
            regex = MIDTRANS_JCB_REGEX;
            break;
        case MIDCreditCardTypeMasterCard:
            regex = MIDTRANS_MASTER_CARD_REGEX;
            break;
        case MIDCreditCardTypeVisa:
            regex = MIDTRANS_VISA_REGEX;
            break;
        default:
            break;
    }
    return [NSPredicate predicateWithFormat:@"SELF MATCHES [c] %@", regex];
}

+(BOOL)isCreditCardNumber:(NSString *_Nonnull)ccNumber eligibleForPromo:(NSArray *_Nonnull)bins error:(NSError *_Nullable*_Nullable)error {
    for (NSString *promoBin in bins) {
        if ([ccNumber containsString:promoBin]) {
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey:NSLocalizedString(@"Your card number is not eligible for promo", nil)};
            *error = [NSError errorWithDomain:MIDTRANS_ERROR_DOMAIN
                                         code:MIDTRANS_ERROR_CODE_INVALID_BIN
                                     userInfo:userInfo];
            return YES;
        }
    }
    
    
    return NO;
    
}
+ (BOOL)isCreditCardNumber:(NSString *_Nonnull)ccNumber containBlacklistBins:(NSArray *_Nonnull)bins error:(NSError *_Nullable*_Nullable)error {
    for (NSString *blackListBins in bins) {
        if ([ccNumber containsString:blackListBins]) {
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey:NSLocalizedString(@"This card is not applicable for this transaction,please use another card", nil)};
            *error = [NSError errorWithDomain:MIDTRANS_ERROR_DOMAIN
                                         code:MIDTRANS_ERROR_CODE_INVALID_BIN
                                     userInfo:userInfo];
            return YES;
        }
    }
    
    
    return NO;
    
}
+ (BOOL)isCreditCardNumber:(NSString *)ccNumber eligibleForBins:(NSArray *)bins error:(NSError **)error {
    for (NSString *whiteListedBin in bins) {
        if ([ccNumber containsString:whiteListedBin]) {
            return YES;
        }
    }
    
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey:NSLocalizedString(@"This card is not applicable for this transaction,please use another card", nil)};
    *error = [NSError errorWithDomain:MIDTRANS_ERROR_DOMAIN
                                 code:MIDTRANS_ERROR_CODE_INVALID_BIN
                             userInfo:userInfo];
    return NO;
}

@end

@implementation UITextField (helper)

- (BOOL)filterNumericWithString:(NSString *)string range:(NSRange)range length:(NSInteger)length {
    if ([string isNumeric] == NO) {
        return NO;
    }
    
    NSMutableString *mstring = self.text.mutableCopy;
    [mstring replaceCharactersInRange:range withString:string];
    return [mstring length] <= length;
}

- (BOOL)filterCvvNumber:(NSString *)string range:(NSRange)range withCardNumber:(NSString *)cardNumber {
    if ([self.text isNumeric] == NO)
        return NO;
    
    NSMutableString *mstring = self.text.mutableCopy;
    [mstring replaceCharactersInRange:range withString:string];
    
    if ([mstring length] <= 6) {
        self.text = mstring;
    }
    return NO;
}

- (BOOL)filterCreditCardExpiryDate:(NSString *)string range:(NSRange)range {
    if ([string isNumeric] == NO) {
        return NO;
    }
    
    NSMutableString *mstring = [NSMutableString stringWithString:self.text];
    if (!string.length && [mstring hasSuffix:ExpiryDateSeparator]) {
        [mstring deleteCharactersInRange:[mstring rangeOfString:ExpiryDateSeparator]];
        [mstring deleteCharactersInRange:NSMakeRange(mstring.length-1, 1)];
    }
    else {
        [mstring replaceCharactersInRange:range withString:string];
    }
    
    [mstring setString:[self removeNonDigits:mstring]];
    
    if (mstring.length > 1 && mstring.length < 5) {
        [mstring insertString:ExpiryDateSeparator atIndex:2];
        self.text = mstring;
    }
    else if (mstring.length < 2) {
        self.text = mstring;
    }
    
    return NO;
}

- (NSString *)removeNonDigits:(NSString *)string {
    if (string.length) {
        NSString *firstChar = [string substringToIndex:1];
        if (firstChar.integerValue > 1) {
            string = [NSString stringWithFormat:@"0%@", string];
        }
    }
    
    NSMutableString *digitsOnlyString = [NSMutableString new];
    for (NSUInteger i=0; i < [string length]; i++) {
        unichar characterToAdd = [string characterAtIndex:i];
        if (isdigit(characterToAdd)) {
            NSString *stringToAdd =
            [NSString stringWithCharacters:&characterToAdd
                                    length:1];
            
            [digitsOnlyString appendString:stringToAdd];
        }
    }
    
    return digitsOnlyString;
}

@end
