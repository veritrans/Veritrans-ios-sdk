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

#define VTVisaRegex         @"^4[0-9]{12}(?:[0-9]{3})?$"
#define VTMasterCardRegex   @"^5[1-5][0-9]{14}$"
#define VTJCBRegex          @"^(?:2131|1800|35\d{3})\d{11}$"
#define VTAmexRegex         @"^3[47][0-9]{13}$"

@implementation NSString (CreditCard)

- (BOOL)isNumeric {
    NSString *numericRegex = @"^[0-9]*$";
    NSPredicate *myTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numericRegex];
    return [myTest evaluateWithObject:self];
}

- (BOOL)isValidCVVWithCreditCardNumber:(NSString *)cardNumber {
    BOOL isAmex = [VTCreditCardHelper typeFromString:[cardNumber stringByReplacingOccurrencesOfString:@" " withString:@""]] == VTCreditCardTypeAmex;
    NSInteger cvvLegth = isAmex ? 4 : 3;    
    return [self isNumeric] && ([self length] == cvvLegth);
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
        NSString *errorMessage = @"Card number is invalid";
        NSInteger numberInvalideCode = -20;
        *error = [NSError errorWithDomain:ErrorDomain code:numberInvalideCode userInfo:@{NSLocalizedDescriptionKey:errorMessage}];
        return NO;
    }
    
    
    if ([self.expiryYear isValidCreditCardExpiryDate] == NO) {
        NSString *errorMessage = @"Expiry Year is invalid";
        NSInteger expiryDateInvalidCode = -21;
        *error = [NSError errorWithDomain:ErrorDomain code:expiryDateInvalidCode userInfo:@{NSLocalizedDescriptionKey:errorMessage}];
        return NO;
    }
    
    if ([self.expiryMonth isValidCreditCardExpiryDate] == NO) {
        NSString *errorMessage = @"Expiry Month is invalid";
        NSInteger expiryDateInvalidCode = -21;
        *error = [NSError errorWithDomain:ErrorDomain code:expiryDateInvalidCode userInfo:@{NSLocalizedDescriptionKey:errorMessage}];
        return NO;
    }
    
    if ([self.cvv isValidCVVWithCreditCardNumber:self.number] == NO) {
        NSString *errorMessage = @"CVV is invalid";
        NSInteger cvvInvalidCode = -22;
        *error = [NSError errorWithDomain:ErrorDomain code:cvvInvalidCode userInfo:@{NSLocalizedDescriptionKey:errorMessage}];
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
            return @"Amex";
        case VTCreditCardTypeJCB:
            return @"JCB";
        case VTCreditCardTypeMasterCard:
            return @"MasterCard";
        case VTCreditCardTypeVisa:
            return @"Visa";
        default:
            return @"";
    }
}

+ (NSPredicate *)predicateForType:(VTCreditCardType)type {
    NSString *regex = nil;
    switch (type) {
        case VTCreditCardTypeAmex:
            regex = @"^3[47][0-9]{5,}$";
            break;
        case VTCreditCardTypeJCB:
            regex = @"^(?:2131|1800|35[0-9]{3})[0-9]{3,}$";
            break;
        case VTCreditCardTypeMasterCard:
            regex = @"^5[1-5][0-9]{5,}$";
            break;
        case VTCreditCardTypeVisa:
            regex = @"^4[0-9]{6,}$";
            break;
        default:
            break;
    }
    return [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
}
@end
