//
//  VTHelper.m
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 2/18/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTHelper.h"

NSString *const VTMaskedCardsUpdated = @"vt_masked_cards_updated";


@implementation VTHelper

+ (id)nullifyIfNil:(id)object {
    if (object) {
        return object;
    } else {
        return [NSNull null];
    }
}

@end


@implementation NSString (random)

+ (NSString *)randomWithLength:(NSUInteger)length {
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity:length];
    for (int i=0; i<length; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform((int)[letters length])]];
    }
    return randomString;
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
        currentFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"id_ID"];
        currentFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
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

@end
