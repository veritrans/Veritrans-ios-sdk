//
//  MidtransHelper.m
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 2/18/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MidtransHelper.h"
#import "MidtransConfig.h"

NSString *const MIdtransMaskedCardsUpdated = @"vt_masked_cards_updated";
NSString *const MIDTRANS_CORE_CURRENCY_IDR = @"IDR";
NSString *const MIDTRANS_CORE_CURRENCY_SGD = @"SGD";

@implementation MidtransHelper

+ (id)nullifyIfNil:(id)object {
    if (object) {
        return object;
    } else {
        return [NSNull new];
    }
}
+ (NSBundle*)coreBundle {
    static dispatch_once_t onceToken;
    static NSBundle *kitBundle = nil;
    dispatch_once(&onceToken, ^{
        //check if bundle is in dynamic framework
        NSURL *bundleURL = [[NSBundle mainBundle] URLForResource:@"Frameworks/MidtransCoreKit.framework/MidtransCoreKit"
                                                   withExtension:@"bundle"];
        if (!bundleURL) {
            bundleURL = [[NSBundle mainBundle] URLForResource:@"MidtransCoreKit"
                                                withExtension:@"bundle"];
        }
        kitBundle = [NSBundle bundleWithURL:bundleURL];
        
    });
    return kitBundle;
}
+ (NSString *)stringFromCurrency:(MidtransCurrency)currency {
    switch (currency) {
        case MidtransCurrencyIDR:
            return MIDTRANS_CORE_CURRENCY_IDR;
            break;
        case MidtransCurrencySGD:
            return MIDTRANS_CORE_CURRENCY_SGD;
            break;
            
        default:
            return MIDTRANS_CORE_CURRENCY_IDR;
            break;
    }
}
+ (MidtransCurrency)currencyFromString:(NSString *)string {
    NSString *uppercaseString = string.uppercaseString;
    if ([uppercaseString.uppercaseString isEqualToString:MIDTRANS_CORE_CURRENCY_SGD]) {
        return MidtransCurrencySGD;
    }
    else if ([uppercaseString isEqualToString:MIDTRANS_CORE_CURRENCY_IDR]) {
        return MidtransCurrencyIDR;
    }
    else {
        return MidtransCurrencyIDR;
    }
}

@end


@implementation NSString (random)

+ (NSString *)randomWithLength:(NSUInteger)length {
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity:length];
    for (int i=0; i < length; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform((int)[letters length])]];
    }
    return randomString;
}

@end

@implementation NSNumber (format)

- (NSString *)roundingWithoutCurrency {
    NSNumberFormatter *currencyFormatter = [NSNumberFormatter multiCurrencyFormatter:CONFIG.currency];
    currencyFormatter.numberStyle = NSNumberFormatterNoStyle;
    return [currencyFormatter stringFromNumber:self];
}

@end

@implementation UIApplication (Utils)

+ (UIViewController *)rootViewController {
    UIViewController *topRootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topRootViewController.presentedViewController) {
        if (![topRootViewController.presentedViewController isKindOfClass:[UIAlertController class]]) {
            topRootViewController = topRootViewController.presentedViewController;
        }
        else {
            break;
        }
    }
    if (!topRootViewController || [topRootViewController isKindOfClass:[UINavigationController class]] || [topRootViewController isKindOfClass:[UITabBarController class]]) {
        
        if (!topRootViewController) {
            topRootViewController = [[[[UIApplication sharedApplication]delegate]window]rootViewController];
        }
        
        if ([topRootViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController* navController = (UINavigationController*)topRootViewController;
            return navController.topViewController;
        }
        else if ([topRootViewController isKindOfClass:[UITabBarController class]]) {
            
            UITabBarController* tabController = (UITabBarController*)topRootViewController;
            
            if ([tabController.selectedViewController isKindOfClass:[UINavigationController class]]) {
                UINavigationController* navController = (UINavigationController*)tabController.selectedViewController;
                return navController.topViewController;
            }
            else {
                return tabController.selectedViewController;
            }
        }
        else {
            return topRootViewController;
        }
    }
    return topRootViewController;
}

@end

@implementation NSMutableDictionary (utilities)

- (id)objectThenDeleteForKey:(NSString *)key {
    id result = [self objectForKey:key];
    [self removeObjectForKey:key];
    return result;
}

@end

@implementation NSObject (utilities)

+ (NSNumberFormatter *)indonesianCurrencyFormatter {
    NSString *identifier = @"VTIndonesianFormatter";
    NSMutableDictionary *dictionary = [[NSThread currentThread] threadDictionary];
    NSNumberFormatter *currentFormatter = [dictionary objectForKey:identifier];
    
    if (currentFormatter == nil) {
        currentFormatter = [NSNumberFormatter new];
        [dictionary setObject:currentFormatter forKey:identifier];
    }
    
    return currentFormatter;
}

+ (NSDateFormatter *)dateFormatterWithIdentifier:(NSString *)identifier {
    NSMutableDictionary *dictionary = [[NSThread currentThread] threadDictionary];
    NSDateFormatter *currentFormatter = [dictionary objectForKey:identifier];
    if (currentFormatter == nil) {
        currentFormatter = [NSDateFormatter new];
        [dictionary setObject:currentFormatter forKey:identifier];
    }
    return currentFormatter;
}

+ (NSNumberFormatter *)multiCurrencyFormatter:(MidtransCurrency)currency {
    NSNumberFormatter *currencyFormatter = [MidtransHelper indonesianCurrencyFormatter];
    currencyFormatter.paddingPosition = NSNumberFormatterPadAfterPrefix;
    if (currency == MidtransCurrencySGD) {
        currencyFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_SG"];
        currencyFormatter.numberStyle = NSNumberFormatterCurrencyISOCodeStyle;
        currencyFormatter.minimumFractionDigits = 2;
        currencyFormatter.roundingMode = NSNumberFormatterRoundHalfEven;
    }
    else {
        //  by default set to indonesian
        currencyFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"id_ID"];
        currencyFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
        currencyFormatter.minimumFractionDigits = 0;
        currencyFormatter.roundingMode = NSNumberFormatterRoundDown;
    }
    return currencyFormatter;
}
@end

