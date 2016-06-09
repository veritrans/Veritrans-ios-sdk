//
//  VTCreditCardHelper.m
//  iossdk-gojek
//
//  Created by Akbar Taufiq Herlangga on 3/23/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTCreditCardHelper.h"
#import "VTLuhn.h"
#import "VTConstant.h"
#import "VTHelper.h"

@implementation NSString (CreditCard)

- (BOOL)isNumeric {
    NSString *numericRegex = @"^(?:|0|[1-9]\\d*)(?:\\.\\d*)?$";
    NSPredicate *myTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numericRegex];
    return [myTest evaluateWithObject:self];
}

- (BOOL)isValidCreditCardCVV {
    return [self isNumeric] && ([self length] == 3);
}

- (BOOL)isValidCreditCardExpiryDate {
    return ([self length] == 2) || ([self length] == 4);
}

- (BOOL)isValidCreditCardNumber {
    return [VTLuhn validateString:self];
}

@end

@implementation VTCreditCard (Validation)

- (BOOL)isValidCreditCard:(NSError **)error {
    if ([self.number isValidCreditCardNumber] == NO) {
        NSString *errorMessage = VT_MESSAGE_CARD_INVALID;
        NSInteger numberInvalideCode = -20;
        *error = [NSError errorWithDomain:ErrorDomain code:numberInvalideCode userInfo:@{NSLocalizedDescriptionKey:errorMessage}];
        return NO;
    }
    
    
    if ([self.expiryYear isValidCreditCardExpiryDate] == NO) {
        NSString *errorMessage = VT_MESSAGE_EXPIRE_DATE_INVALID;
        NSInteger expiryDateInvalidCode = -21;
        *error = [NSError errorWithDomain:ErrorDomain code:expiryDateInvalidCode userInfo:@{NSLocalizedDescriptionKey:errorMessage}];
        return NO;
    }
    
    if ([self.expiryMonth isValidCreditCardExpiryDate] == NO) {
        NSString *errorMessage = VT_MESSAGE_EXPIRE_MONTH_INVALID;
        NSInteger expiryDateInvalidCode = -21;
        *error = [NSError errorWithDomain:ErrorDomain code:expiryDateInvalidCode userInfo:@{NSLocalizedDescriptionKey:errorMessage}];
        return NO;
    }
    
    if ([self.cvv isValidCreditCardCVV] == NO) {
        NSString *errorMessage = VT_MESSAGE_CARD_CVV_INVALID;
        NSInteger cvvInvalidCode = -22;
        *error = [NSError errorWithDomain:ErrorDomain code:cvvInvalidCode userInfo:@{NSLocalizedDescriptionKey:errorMessage}];
        return NO;
    }
    
    return YES;
}

@end

@implementation VTCreditCardHelper

+ (VTCreditCardType) typeFromString:(NSString *) string {
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

+ (NSPredicate *) predicateForType:(VTCreditCardType) type {
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
