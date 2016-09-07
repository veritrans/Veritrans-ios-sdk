//
//  VTCreditCardHelper.m
//  iossdk-gojek
//
//  Created by Akbar Taufiq Herlangga on 3/23/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MTCreditCardHelper.h"
#import "MTLuhn.h"
#import "VTHelper.h"
#import "MTConstant.h"

@implementation NSString (CreditCard)

- (BOOL)isNumeric {
    NSString *numericRegex = @"^[0-9]*$";
    NSPredicate *myTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numericRegex];
    return [myTest evaluateWithObject:self];
}

- (BOOL)isValidCVVWithCreditCardNumber:(NSString *)cardNumber error:(NSError **)error {
    BOOL isAmex = [MTCreditCardHelper typeFromString:[cardNumber stringByReplacingOccurrencesOfString:@" " withString:@""]] == VTCreditCardTypeAmex;
    NSInteger cvvLegth = isAmex ? 4 : 3;
    BOOL valid = [self isNumeric] && ([self length] == cvvLegth);
    
    if (valid) {
        return YES;
    } else {
        NSString *errorMessage = NSLocalizedString(MT_MESSAGE_CARD_CVV_INVALID, nil);
        *error = [NSError errorWithDomain:MT_ERROR_DOMAIN code:MT_ERROR_CODE_INVALIDCVV userInfo:@{NSLocalizedDescriptionKey:errorMessage}];
        return NO;
    }
}

- (BOOL)isValidYearExpiryDate:(NSError **)error {
    BOOL formatValid = ([self length] == 2) || ([self length] == 4);
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yy";
    NSInteger currentYear = [[df stringFromDate:[NSDate date]] integerValue];
    BOOL yearExpired = [self integerValue] < currentYear;
    
    if (formatValid && !yearExpired) {
        return YES;
    }
    
    NSString *errorMessage = NSLocalizedString(MT_MESSAGE_EXPIRE_DATE_INVALID, nil);
    *error = [NSError errorWithDomain:MT_ERROR_DOMAIN code:MT_ERROR_CODE_INVALID_EXPIRY_DATE userInfo:@{NSLocalizedDescriptionKey:errorMessage}];
    
    return NO;
}

- (BOOL)isValidMonthExpiryDate:(NSError **)error {
    BOOL valid = ([self length] == 2) || ([self length] == 4);
    if (valid) {
        return YES;
    } else {
        NSString *errorMessage = NSLocalizedString(MT_MESSAGE_EXPIRE_MONTH_INVALID, nil);
        *error = [NSError errorWithDomain:MT_ERROR_DOMAIN code:MT_ERROR_CODE_INVALID_EXPIRY_DATE userInfo:@{NSLocalizedDescriptionKey:errorMessage}];
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

- (BOOL)isValidCreditCardNumber:(NSError **)error {
    if ([MTLuhn validateString:self]) {
        return YES;
    } else {
        NSString *errorMessage = NSLocalizedString(MT_MESSAGE_CARD_INVALID, nil);
        *error = [NSError errorWithDomain:MT_ERROR_DOMAIN code:MT_ERROR_CODE_INVALID_CC_NUMBER userInfo:@{NSLocalizedDescriptionKey:errorMessage}];
        return NO;
    }
}

@end

@implementation MTCreditCard (Validation)

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

@implementation MTCreditCardHelper

+ (MTCreditCardType)typeFromString:(NSString *)string {
    NSString *formattedString = [string formattedStringForProcessing];
    NSArray *enums = @[@(VTCreditCardTypeVisa), @(VTCreditCardTypeMasterCard), @(VTCreditCardTypeJCB), @(VTCreditCardTypeAmex)];
    
    __block MTCreditCardType type = VTCreditCardTypeUnknown;
    [enums enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        MTCreditCardType _type = [obj integerValue];
        NSPredicate *predicate = [MTCreditCardHelper predicateForType:_type];
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
        case VTCreditCardTypeAmex:
            return CREDIT_CARD_TYPE_AMEX;
        case VTCreditCardTypeJCB:
            return CREDIT_CARD_TYPE_JCB;
        case VTCreditCardTypeMasterCard:
            return CREDIT_CARD_TYPE_MASTER_CARD;
        case VTCreditCardTypeVisa:
            return CREDIT_CARD_TYPE_VISA;
        default:
            return @"";
    }
}

+ (NSPredicate *)predicateForType:(MTCreditCardType)type {
    NSString *regex = nil;
    switch (type) {
        case VTCreditCardTypeAmex:
            regex = MT_AMEX_REGEX;
            break;
        case VTCreditCardTypeJCB:
            regex = MT_JCB_REGEX;
            break;
        case VTCreditCardTypeMasterCard:
            regex = MT_MASTER_CARD_REGEX;
            break;
        case VTCreditCardTypeVisa:
            regex = MT_VISA_REGEX;
            break;
        default:
            break;
    }
    return [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
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
    
    BOOL isAmex = [MTCreditCardHelper typeFromString:[cardNumber stringByReplacingOccurrencesOfString:@" " withString:@""]] == VTCreditCardTypeAmex;
    NSInteger cvvLength = isAmex ? 4 : 3;
    
    NSMutableString *mstring = self.text.mutableCopy;
    [mstring replaceCharactersInRange:range withString:string];
    
    if ([mstring length] <= cvvLength) {
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

- (NSString *)removeNonDigits:(NSString *)string
{
    if (string.length) {
        NSString *firstChar = [string substringToIndex:1];
        if (firstChar.integerValue > 1) {
            string = [NSString stringWithFormat:@"0%@", string];
        }
    }
    
    NSMutableString *digitsOnlyString = [NSMutableString new];
    for (NSUInteger i=0; i<[string length]; i++) {
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
