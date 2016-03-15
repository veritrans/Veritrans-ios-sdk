//
//  VTClassHelper.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 2/23/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTClassHelper.h"

NSString *const VTCreditCardIdentifier = @"cc";

NSString *const VTMandiriClickpayIdentifier = @"clickpay";
NSString *const VTCIMBClicksIdentifier = @"clicks";
NSString *const VTBCAKlikpayIdentifier = @"klikpay";
NSString *const VTBRIEpayIdentifier = @"epay";

NSString *const VTIndomaretIdentifier = @"indomaret";

NSString *const VTMandiriECashIdentifier = @"ecash";
NSString *const VTBBMIdentifier = @"bbm";
NSString *const VTIndosatDompetkuIdentifier = @"dompetku";
NSString *const VTTCashIdentifier = @"tcash";
NSString *const VTXLTunaiIdentifier = @"xltunai";

NSString *const VTVAIdentifier = @"va";
NSString *const VTPermataVAIdentifier = @"permatava";
NSString *const VTBCAVAIdentifier = @"bcava";
NSString *const VTMandiriVAIdentifier = @"mandiriva";
NSString *const VTOtherVAIdentifier = @"otherva";

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

- (BOOL)filterCvvNumber:(NSString *)string range:(NSRange)range {
    if ([string isNumeric] == NO) {
        return NO;
    }
    
    NSMutableString *mstring = self.text.mutableCopy;
    [mstring replaceCharactersInRange:range withString:string];
    return [mstring length] <= 3;
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

@implementation NSObject (utilities)

+ (NSNumberFormatter *)numberFormatterWith:(NSString *)identifier {
    NSMutableDictionary *dictionary = [[NSThread currentThread] threadDictionary];
    NSNumberFormatter *currentFormatter = [dictionary objectForKey:identifier];
    
    if (currentFormatter == nil) {
        currentFormatter = [NSNumberFormatter new];
        currentFormatter.numberStyle = NSNumberFormatterDecimalStyle;
        [dictionary setObject:currentFormatter forKey:identifier];
    }
    
    return currentFormatter;
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


