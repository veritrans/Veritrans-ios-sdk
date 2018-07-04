//
//  MDUtils.m
//  MidtransDemo
//
//  Created by Nanang Rafsanjani on 3/23/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import "MDUtils.h"
#import "MDOptionManager.h"

@implementation MDUtils

+ (MidtransPaymentRequestV2Installment *)installmentOfBank:(NSString *)bank isRequired:(BOOL)required {
    
    if ([bank isEqualToString:@"cimb"] || [bank isEqualToString:@"CIMB"]) {
         return [MidtransPaymentRequestV2Installment modelWithTerms:@{bank:@[@3,@6,@12]} isRequired:required];
    }
    return [MidtransPaymentRequestV2Installment modelWithTerms:@{bank:@[@3,@6,@12]} isRequired:required];
}
+ (void)saveOptionWithView:(MDOptionView *)view option:(MDOption *)option {
    NSString *idf = view.identifier;
    if ([idf isEqualToString:OPTSaveCard]) {
        [MDOptionManager shared].saveCardOption = option;
    }
    else if ([idf isEqualToString:OPT3DSecure]) {
        [MDOptionManager shared].secure3DOption = option;
    }
    else if ([idf isEqualToString:OPTColor]) {
        [MDOptionManager shared].colorOption = option;
    }
    else if ([idf isEqualToString:OPTAuthType]) {
        [MDOptionManager shared].authTypeOption = option;
    }
    else if ([idf isEqualToString:OPTPromo]) {
        [MDOptionManager shared].promoOption = option;
    }
    else if ([idf isEqualToString:OPTPreauth]) {
        [MDOptionManager shared].preauthOption = option;
    }
    else if ([idf isEqualToString:OPTBNIPoint]) {
        [MDOptionManager shared].bniPointOption = option;
    }
    else if ([idf isEqualToString:OPTMandiriPoint]) {
        [MDOptionManager shared].mandiriPointOption = option;
    }
    else if ([idf isEqualToString:OPTCustomExpire]) {
        [MDOptionManager shared].expireTimeOption = option;
    }
    else if ([idf isEqualToString:OPTCurrency]) {
        [MDOptionManager shared].currencyOption = option;
    }
    else if ([idf isEqualToString:OPTAcquiringBank]) {
        [MDOptionManager shared].issuingBankOption = option;
    }
    else if ([idf isEqualToString:OPTCreditCardFeature]) {
        [MDOptionManager shared].ccTypeOption = option;
    }
    else if ([idf isEqualToString:OPTBCAVA]) {
        [MDOptionManager shared].bcaVAOption = option;
    }
    else if ([idf isEqualToString:OPTBNIVA]) {
        [MDOptionManager shared].bniVAOption = option;
    }
    else if ([idf isEqualToString:OPTPermataVA]) {
        [MDOptionManager shared].permataVAOption = option;
    }
    else if ([idf isEqualToString:OPTCustomField]) {
        [MDOptionManager shared].customFieldOption = option;
    }
    else if ([idf isEqualToString:OPTInstallment]) {
        [MDOptionManager shared].installmentOption = option;
    }
    else if ([idf isEqualToString:OPTPaymanetChannel]) {
        [MDOptionManager shared].paymentChannel = option;
    }
}

+ (NSArray <MDPayment*>*)paymentChannelsWithNames:(NSArray <NSString*>*)names {
    NSArray *allChannels = [self allPaymentChannels];
    NSMutableArray *result = [NSMutableArray new];
    for (MDPayment *channel in allChannels) {
        if ([names containsObject:channel.name]) {
            [result addObject:channel];
        }
    }
    return  result;
}
+ (NSArray <MDPayment*>*)allPaymentChannels {
    NSString *rawChannelsPath = [[NSBundle mainBundle] pathForResource:@"payment_channels" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:rawChannelsPath];
    NSArray *rawChannels = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSMutableArray *channels = [NSMutableArray new];
    for (id rawChannel in rawChannels) {
        MDPayment *channel = [MDPayment modelObjectWithDictionary:rawChannel];
        [channels addObject:channel];
    }
    return channels;
}

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

@implementation UIColor (Midtrans)

+ (UIColor *)mdDarkColor {
    return [UIColor colorWithRed:3/255. green:3/255. blue:3/255. alpha:1];
}
+ (UIColor *)mdThemeColor {
    return [[MDOptionManager shared] colorOption].value;
}

- (BOOL)isEqualToColor:(UIColor *)otherColor {
    CGFloat r1, g1, b1, a1, r2, g2, b2, a2;
    [self getRed:&r1 green:&g1 blue:&b1 alpha:&a1];
    [otherColor getRed:&r2 green:&g2 blue:&b2 alpha:&a2];
    return
    fabs(r1 - r2) <= 0.01 &&
    fabs(g1 - g2) <= 0.01 &&
    fabs(b1 - b2) <= 0.01 &&
    fabs(a1 - a2) <= 0.01;
}
@end

@implementation UIFont (Midtrans)
+ (UIFont *)bariolRegularWithSize:(CGFloat)size {
    return [UIFont fontWithName:@"Bariol-Regular" size:size];
}
+ (UIFont *)ssProLightWithSize:(CGFloat)size {
    return [UIFont fontWithName:@"SourceSansPro-Light" size:size];
}
@end

@implementation NSString (Utils)

+ (NSString *)randomWithLength:(NSUInteger)length {
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity:length];
    for (int i=0; i < length; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform((int)[letters length])]];
    }
    return randomString;
}

@end

@implementation NSArray (Option)

- (NSInteger)indexOfOption:(MDOption *)option {
    NSUInteger index = [self indexOfObjectPassingTest:^BOOL(MDOption *_option, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([_option.name isEqual:option.name]) {
            _option.value = option.value;
            _option.subName = option.subName;
            return YES;
        }
        else {
            return NO;
        }
    }];
    
    if (index == NSNotFound) {
        return 0;
    }
    return index;
}

@end
