//
//  MDUtils.h
//  MidtransDemo
//
//  Created by Nanang Rafsanjani on 3/23/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MDOption.h"
#import "MDPayment.h"

#define defaults()                          [NSUserDefaults standardUserDefaults]
#define defaults_init(dictionary)			[defaults() registerDefaults:dictionary]
#define defaults_save()                     [defaults() synchronize]
#define defaults_object(key)                [defaults() objectForKey:key]
#define defaults_set_object(key, object)    [defaults() setObject:object forKey:key]; defaults_save(); defaults_post_notification(key)
#define defaults_remove(key)                [defaults() removeObjectForKey:key]; defaults_save();

#define defaults_object_from_notification(n) [n.userInfo objectForKey:@"value"]
#define defaults_observe_object(key, block) [[NSNotificationCenter defaultCenter] addObserverForName:key object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *n){ block( defaults_object_from_notification(n) ); }]
#define defaults_post_notification(defaults_key) [[NSNotificationCenter defaultCenter] postNotificationName:defaults_key object:nil userInfo:@{ @"value" : defaults_object(defaults_key) }]

#define RGB(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define RGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]

static NSString *const OPTCreditCardFeature = @"OPTCreditCardFeature";
static NSString *const OPT3DSecure = @"OPT3DSecure";
static NSString *const OPTAcquiringBank = @"OPTAcquiringBank";
static NSString *const OPTCustomExpire = @"OPTCustomExpire";
static NSString *const OPTSaveCard = @"OPTSaveCard";
static NSString *const OPTPromo = @"OPTPromo";
static NSString *const OPTPreauth = @"OPTPreauth";
static NSString *const OPTColor = @"OPTColor";
static NSString *const OPTBNIPoint = @"OPTBNIPoint";
static NSString *const OPTPermataVA = @"OPTPermataVA";
static NSString *const OPTBCAVA = @"OPTBCAVA";
static NSString *const OPTInstallment = @"OPTInstallment";
static NSString *const OPTPaymanetChannel = @"OPTPaymanetChannel";

@interface MDUtils : NSObject
+ (NSArray <MDPayment*>*)paymentChannelsWithNames:(NSArray <NSString*>*)names;
+ (NSArray <MDPayment*>*)allPaymentChannels;
+ (UIViewController *)rootViewController;
@end

@interface UIColor (Midtrans)
+ (UIColor *)mdDarkColor;
+ (UIColor *)mdThemeColor;
- (BOOL)isEqualToColor:(UIColor *)otherColor;
@end

@interface UIFont (Midtrans)
+ (UIFont *)bariolRegularWithSize:(CGFloat)size;
+ (UIFont *)ssProLightWithSize:(CGFloat)size;
@end

@interface NSString (Utils)
+ (NSString *)randomWithLength:(NSUInteger)length;
@end

@interface NSArray (Option)
- (NSInteger)indexOfOption:(MDOption *)option;
@end
