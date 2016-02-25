//
//  VTClassHelper.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 2/23/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTClassHelper.h"

@implementation VTClassHelper

+ (NSBundle*)kitBundle {
    static dispatch_once_t onceToken;
    static NSBundle *kitBundle = nil;
    dispatch_once(&onceToken, ^{
        @try {
            kitBundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"MidtransResources" withExtension:@"bundle"]];
        }
        @catch (NSException *exception) {
            kitBundle = [NSBundle mainBundle];
        }
        @finally {
            [kitBundle load];
        }
    });
    return kitBundle;
}

@end

@implementation NSString (utilities)

- (BOOL)isNumeric {
    NSCharacterSet* nonNumbers = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSRange r = [self rangeOfCharacterFromSet: nonNumbers];
    return r.location == NSNotFound;
}

@end

@implementation UITextField (helper)

- (BOOL)filterCreditCardExpiryDate:(NSString *)string range:(NSRange)range {
    if ([string isNumeric] == NO) {
        return NO;
    }
    
    NSMutableString *changedString = self.text.mutableCopy;
    [changedString replaceCharactersInRange:range withString:string];
    
    if ([changedString length] == 1 && [changedString integerValue] > 1) {
        self.text = [NSString stringWithFormat:@"0%@/", changedString];
    } else if ([changedString length] == 2) {
        if ([changedString integerValue] < 13) {
            self.text = changedString;
        }
    } else if ([changedString length] == 3) {
        if ([string length]) {
            [changedString insertString:@"/" atIndex:2];
        }
        self.text = changedString;
    } else if ([changedString length] < 6) {
        self.text = changedString;
    }
    return NO;
}

@end


