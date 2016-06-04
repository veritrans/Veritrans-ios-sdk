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

#define VTVisaRegex         @"^4[0-9]{6,}$"
#define VTMasterCardRegex   @"^5[1-5][0-9]{5,}$"
#define VTJCBRegex          @"^(?:2131|1800|35[0-9]{3})[0-9]{3,}$"
#define VTAmexRegex         @"^3[47][0-9]{5,}$"

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
    return [self isNumeric] && ([self length] == 2);
}

- (BOOL)isValidCreditCardNumber {
    return [VTLuhn validateString:self];
}

- (VTCreditCardType)creditCardType {
    if([self length] < 4) return VTCreditCardTypeUnknown;
    
    VTCreditCardType cardType;
    NSRegularExpression *regex;
    NSError *error;
    
    for(NSUInteger i = 0; i < VTCreditCardTypeUnknown; ++i) {
        
        cardType = i;
        
        switch(i) {
            case VTCreditCardTypeVisa:
                regex = [NSRegularExpression regularExpressionWithPattern:VTVisaRegex options:0 error:&error];
                break;
            case VTCreditCardTypeMasterCard:
                regex = [NSRegularExpression regularExpressionWithPattern:VTMasterCardRegex options:0 error:&error];
                break;
            case VTCreditCardTypeJCB :
                regex = [NSRegularExpression regularExpressionWithPattern:VTJCBRegex options:0 error:&error];
                break;
            case VTCreditCardTypeAmex:
                regex = [NSRegularExpression regularExpressionWithPattern:VTAmexRegex options:0 error:&error];
                break;
        }
        
        NSUInteger matches = [regex numberOfMatchesInString:self options:0 range:NSMakeRange(0, 4)];
        if(matches == 1) return cardType;
    }
    
    return VTCreditCardTypeUnknown;
}

- (NSString *)creditCardName {
    switch (self.creditCardType) {
        case VTCreditCardTypeVisa:
            return @"Visa";
            break;
        case VTCreditCardTypeMasterCard:
            return @"MasterCard";
            break;
        case VTCreditCardTypeJCB:
            return @"JCB";
            break;
        case VTCreditCardTypeAmex:
            return @"Amex";
            break;
        case VTCreditCardTypeUnknown:
            return @"";
            break;
    }
}

@end

@implementation VTCreditCard (Validation)

- (BOOL)isValidCreditCard:(NSError **)error {
    if ([self.number isValidCreditCardNumber] == NO) {
        NSString *errorMessage = @"Credit Card number is invalid";
        *error = [NSError errorWithDomain:ErrorDomain code:-20 userInfo:@{NSLocalizedDescriptionKey:errorMessage}];
        return NO;
    }
    
    if ([self.expiryYear isValidCreditCardExpiryDate] == NO ||
        [self.expiryMonth isValidCreditCardExpiryDate] == NO) {
        NSString *errorMessage = @"Expiry Date is invalid";
        *error = [NSError errorWithDomain:ErrorDomain code:-20 userInfo:@{NSLocalizedDescriptionKey:errorMessage}];
        return NO;
    }
    
    if ([self.cvv isValidCreditCardCVV] == NO) {
        NSString *errorMessage = @"CVV number is invalid";
        *error = [NSError errorWithDomain:ErrorDomain code:-22 userInfo:@{NSLocalizedDescriptionKey:errorMessage}];
        return NO;
    }
    
    return YES;
}

@end

@implementation VTCreditCardHelper

@end
