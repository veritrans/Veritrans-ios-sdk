//
//  VTClassHelper.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 2/23/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTClassHelper.h"
#import <MidtransCoreKit/MidtransCoreKit.h>

@implementation NSNumber (formatter)

- (NSString *)formattedCurrencyNumber {
    NSNumberFormatter *nf = [NSNumberFormatter indonesianCurrencyFormatter];
    return [@"Rp " stringByAppendingString:[nf stringFromNumber:self]];
}

@end

@implementation VTClassHelper

+ (NSBundle*)kitBundle {
    static dispatch_once_t onceToken;
    static NSBundle *kitBundle = nil;
    dispatch_once(&onceToken, ^{
        @try {
            kitBundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"MidtransKit" withExtension:@"bundle"]];
        }
        @catch (NSException *exception) {
            kitBundle = [NSBundle mainBundle];
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

- (NSString *)formattedCreditCardNumber {
    NSString *cardNumber = self;
    NSString *result = @"";
    
    while (cardNumber.length > 0) {
        NSString *subString = [cardNumber substringToIndex:MIN(cardNumber.length, 4)];
        result = [result stringByAppendingString:subString];
        if (subString.length == 4) {
            result = [result stringByAppendingString:@" "];
        }
        cardNumber = [cardNumber substringFromIndex:MIN(cardNumber.length, 4)];
    }
    return result;
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
    
    if ([mstring length] == 1 && [mstring integerValue] > 1) {
        self.text = [NSString stringWithFormat:@"0%@/", mstring];
    } else if ([mstring length] == 2) {
        if ([mstring integerValue] < 13) {
            self.text = mstring;
        }
    } else if ([mstring length] == 3) {
        if ([string length]) {
            [mstring insertString:@"/" atIndex:2];
        }
        self.text = mstring;
    } else if ([mstring length] < 6) {
        self.text = mstring;
    }
    return NO;
}

@end

@implementation UILabel (utilities)

- (void)setRoundedCorners:(BOOL)rounded {
    if (rounded) {
        self.layer.cornerRadius = CGRectGetHeight(self.bounds)/2.0;
    } else {
        self.layer.cornerRadius = 0;
    }
}

@end

@implementation UIViewController (Utils)

- (void)addSubViewController:(UIViewController *)viewController toView:(UIView*)contentView {
    
    [self addChildViewController:viewController];
    [viewController didMoveToParentViewController:self];
    
    viewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    [contentView addSubview:viewController.view];
    
    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[content]|" options:0 metrics:0 views:@{@"content":viewController.view}]];
    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[content]|" options:0 metrics:0 views:@{@"content":viewController.view}]];
}

- (void)removeSubViewController:(UIViewController *)viewController {
    [viewController.view removeFromSuperview];
    [viewController removeFromParentViewController];
    [viewController didMoveToParentViewController:nil];
}

@end


