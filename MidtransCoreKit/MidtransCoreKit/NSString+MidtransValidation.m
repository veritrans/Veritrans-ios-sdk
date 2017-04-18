//
//  NSString+VTValidation.m
//  MidtransCoreKit
//
//  Created by Arie on 6/17/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "NSString+MidtransValidation.h"

@implementation NSString (MidtransValidation)

- (BOOL)SNPisEmpty {
    NSString *string = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    return (string.length == 0);
}

- (BOOL)SNPisValidClickpayNumber {
    NSString *formatted = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *regex = @"^[0-9]{16}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES[c] %@", regex];
    return [predicate evaluateWithObject:formatted];
}

- (BOOL)SNPisValidClickpayToken {
    NSString *regex = @"^[0-9]{6}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES[c] %@", regex];
    return [predicate evaluateWithObject:self];
}

- (BOOL)SNPisValidEmail {
    NSString *emailRegex =
    @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES[c] %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

- (BOOL)SNPisValidCommonName {
    NSString *nameRegex = @"^[a-z ]+$";
    NSPredicate *nameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES[c] %@", nameRegex];
    return [nameTest evaluateWithObject:self];
}

- (BOOL)SNPisValidNumber {
    NSString *numberRegex = @"^[0-9]*$";
    NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES[c] %@", numberRegex];
    return [numberTest evaluateWithObject:self];
}

- (BOOL)SNPisValidPhoneNumber {
    NSString *phoneNumberRegex = @"^\\+?[0-9]*$";
    NSPredicate *phoneNumberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES[c] %@", phoneNumberRegex];
    return [phoneNumberTest evaluateWithObject:self] && self.length >= 6;
}

- (BOOL)SNPisValidUsingPlusPhoneNumber {
    NSString *phoneNumberRegex = @"^\\+[0-9]*$";
    NSPredicate *phoneNumberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES[c] %@", phoneNumberRegex];
    return [phoneNumberTest evaluateWithObject:self];
}

@end
