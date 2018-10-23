//
//  MidtransHelper.h
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 2/18/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MidtransCurrency) {
    MidtransCurrencyIDR,
    MidtransCurrencySGD
};

extern NSString *const MidtransMaskedCardsUpdated;

@interface MidtransHelper : NSObject
+ (id)nullifyIfNil:(id)object;
+ (NSBundle*)coreBundle;
+ (NSString *)stringFromCurrency:(MidtransCurrency)currency;
+ (MidtransCurrency)currencyFromString:(NSString *)string;
@end

@interface NSString (random)
+ (NSString *)randomWithLength:(NSUInteger)length;
@end

@interface NSNumber (format)
- (NSString *)roundingWithoutCurrency;
@end

@interface UIApplication (utilities)
+ (UIViewController *)rootViewController;
@end

@interface NSMutableDictionary (utilities)
- (id)objectThenDeleteForKey:(NSString *)key;
@end

@interface NSObject (utilities)
+ (NSNumberFormatter *)indonesianCurrencyFormatter;
+ (NSDateFormatter *)dateFormatterWithIdentifier:(NSString *)identifier;
+ (NSNumberFormatter *)multiCurrencyFormatter:(MidtransCurrency)currency;
@end

//
//@interface NSDictionary (SafeObject)
//- (id)safeObjectForKey:(id)key;
//- (id)safeValueForKeyPath:(NSString*)keyPath;
//- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;
//@end
