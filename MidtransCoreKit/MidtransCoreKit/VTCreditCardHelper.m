//
//  VTCreditCardHelper.m
//  iossdk-gojek
//
//  Created by Akbar Taufiq Herlangga on 3/23/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTCreditCardHelper.h"
#import "VTLuhn.h"
#import "VTHelper.h"
#import "VTConstant.h"

#define VTVisaRegex         @"^4[0-9]{12}(?:[0-9]{3})?$"
#define VTMasterCardRegex   @"^5[1-5][0-9]{14}$"
#define VTJCBRegex          @"^(?:2131|1800|35\d{3})\d{11}$"
#define VTAmexRegex         @"^3[47][0-9]{13}$"

static NSString * const ExpiryDateSeparator = @" / ";

@implementation NSString (CreditCard)

- (BOOL)isNumeric {
    NSString *numericRegex = @"^[0-9]*$";
    NSPredicate *myTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numericRegex];
    return [myTest evaluateWithObject:self];
}

- (BOOL)isValidCVVWithCreditCardNumber:(NSString *)cardNumber error:(NSError **)error {
    BOOL isAmex = [VTCreditCardHelper typeFromString:[cardNumber stringByReplacingOccurrencesOfString:@" " withString:@""]] == VTCreditCardTypeAmex;
    NSInteger cvvLegth = isAmex ? 4 : 3;
    BOOL valid = [self isNumeric] && ([self length] == cvvLegth);
    
    if (valid) {
        return YES;
    } else {
        NSString *errorMessage = NSLocalizedString(VT_MESSAGE_CARD_CVV_INVALID, nil);
        NSInteger cvvInvalidCode = -22;
        *error = [NSError errorWithDomain:VT_ERROR_DOMAIN code:cvvInvalidCode userInfo:@{NSLocalizedDescriptionKey:errorMessage}];
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
    
    NSString *errorMessage = NSLocalizedString(VT_MESSAGE_EXPIRE_DATE_INVALID, nil);
    NSInteger expiryDateInvalidCode = -21;
    *error = [NSError errorWithDomain:VT_ERROR_DOMAIN code:expiryDateInvalidCode userInfo:@{NSLocalizedDescriptionKey:errorMessage}];
    
    return NO;
}

- (BOOL)isValidMonthExpiryDate:(NSError **)error {
    BOOL valid = ([self length] == 2) || ([self length] == 4);
    if (valid) {
        return YES;
    } else {
        NSString *errorMessage = NSLocalizedString(VT_MESSAGE_EXPIRE_MONTH_INVALID, nil);
        NSInteger expiryDateInvalidCode = -21;
        *error = [NSError errorWithDomain:VT_ERROR_DOMAIN code:expiryDateInvalidCode userInfo:@{NSLocalizedDescriptionKey:errorMessage}];
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
    if ([VTLuhn validateString:self]) {
        return YES;
    } else {
        NSString *errorMessage = NSLocalizedString(VT_MESSAGE_CARD_INVALID, nil);
        NSInteger numberInvalideCode = -20;
        *error = [NSError errorWithDomain:VT_ERROR_DOMAIN code:numberInvalideCode userInfo:@{NSLocalizedDescriptionKey:errorMessage}];
        return NO;
    }
}

@end

@implementation VTCreditCard (Validation)

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

@implementation VTCreditCardHelper

+ (VTCreditCardType)typeFromString:(NSString *)string {
    NSString *formattedString = [string formattedStringForProcessing];
    NSArray *enums = @[@(VTCreditCardTypeVisa), @(VTCreditCardTypeMasterCard), @(VTCreditCardTypeJCB), @(VTCreditCardTypeAmex)];
    
    __block VTCreditCardType type = VTCreditCardTypeUnknown;
    [enums enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        VTCreditCardType _type = [obj integerValue];
        NSPredicate *predicate = [VTCreditCardHelper predicateForType:_type];
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

+ (NSPredicate *)predicateForType:(VTCreditCardType)type {
    NSString *regex = nil;
    switch (type) {
        case VTCreditCardTypeAmex:
            regex = VT_AMEX_REGEX;
            break;
        case VTCreditCardTypeJCB:
            regex = VT_JCB_REGEX;
            break;
        case VTCreditCardTypeMasterCard:
            regex = VT_MASTER_CARD_REGEX;
            break;
        case VTCreditCardTypeVisa:
            regex = VT_VISA_REGEX;
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

- (BOOL)filterCreditCardWithString:(NSString *)string range:(NSRange)range {
    NSString *text = self.text;
    
    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789\b"];
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([string rangeOfCharacterFromSet:[characterSet invertedSet]].location != NSNotFound) {
        return NO;
    }
    
    text = [text stringByReplacingCharactersInRange:range withString:string];
    text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSString *newString = @"";
    while (text.length > 0) {
        NSString *subString = [text substringToIndex:MIN(text.length, 4)];
        newString = [newString stringByAppendingString:subString];
        if (subString.length == 4) {
            newString = [newString stringByAppendingString:@" "];
        }
        text = [text substringFromIndex:MIN(text.length, 4)];
    }
    
    newString = [newString stringByTrimmingCharactersInSet:[characterSet invertedSet]];
    
    if (newString.length >= 20) {
        return NO;
    }
    
    [self setText:newString];
    
    return NO;
}

- (BOOL)filterCvvNumber:(NSString *)string range:(NSRange)range withCardNumber:(NSString *)cardNumber {
    if ([self.text isNumeric] == NO)
        return NO;
    
    BOOL isAmex = [VTCreditCardHelper typeFromString:[cardNumber stringByReplacingOccurrencesOfString:@" " withString:@""]] == VTCreditCardTypeAmex;
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
    
    NSMutableString *mstring = self.text.mutableCopy;
    [mstring replaceCharactersInRange:range withString:string];
    
    if (mstring.length == 1 && mstring.integerValue > 1) {
        self.text = [NSString stringWithFormat:@"0%@", mstring];
    }
    else if (self.text.length == 2 && string.length) {
        self.text = [NSString stringWithFormat:@"%@%@%@", self.text, ExpiryDateSeparator, string];
    }
    else if ([self.text hasSuffix:ExpiryDateSeparator] && string.length == 0) {
        self.text = [self.text stringByReplacingOccurrencesOfString:ExpiryDateSeparator withString:@""];
    }
    else if (mstring.length < 8) {
        self.text = mstring;
    }
    
    return NO;
}

@end
