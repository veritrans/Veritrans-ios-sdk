//
//  VTClassHelper.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 2/23/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTClassHelper.h"

NSString *const VTPaymentCreditCard = @"cc";
NSString *const VTPaymentPermataVA = @"permatava";
NSString *const VTPaymentMandiriClickpay = @"clickpay";
NSString *const VTPaymentBCAVA = @"bcava";
NSString *const VTPaymentMandiriBillpay = @"billpay";
NSString *const VTPaymentCIMBClicks = @"clicks";
NSString *const VTPaymentBCAKlikpay = @"klikpay";
NSString *const VTPaymentIndomaret = @"indomaret";
NSString *const VTPaymentMandiriECash = @"ecash";

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
        currentFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
        currentFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"id_ID"];
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

@implementation UIApplication (Utils)

+ (UIViewController *)rootViewController {
    UIViewController *base = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    if ([base isKindOfClass:[UINavigationController class]]) {
        return [(UINavigationController *)base visibleViewController];
    } else if ([base isKindOfClass:[UITabBarController class]]) {
        return [(UITabBarController *)base selectedViewController];
    } else {
        if ([base presentedViewController]) {
            return [base presentedViewController];
        } else {
            return base;
        }
    }
}


@end


