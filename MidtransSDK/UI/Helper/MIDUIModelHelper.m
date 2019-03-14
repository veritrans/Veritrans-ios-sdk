//
//  MIDUIModelHelper.m
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 05/03/19.
//  Copyright © 2019 Midtrans. All rights reserved.
//

#import "MIDUIModelHelper.h"
#import "MIDCreditCardHelper.h"
#import "MIDLuhn.h"
#import "MIDConstants.h"
#import "MidtransDeviceHelper.h"
#import "NSString+MidtransValidation.h"

@implementation MIDUIModelHelper

@end

@implementation MIDPaymentResult (utils)

- (NSString *)codeForLocalization {
    switch (self.statusCode) {
            case 200:
            return @"error_200";
            case 201:
            return @"error_201";
            case 202:
            return @"error_202";
            case 400:
            return @"error_400";
            case 502:
            return @"error_502";
            case 406:
            return @"error_406";
            case 407:
            return @"error_407";
            case 500:
            return @"error_500";
        default:
            return @"error_others";
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
