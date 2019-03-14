//
//  MidtransHelper.h
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 2/18/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MidtransSDK.h"

extern NSString *const MidtransMaskedCardsUpdated;

@interface MidtransHelper : NSObject
+ (id)nullifyIfNil:(id)object;
+ (NSBundle*)coreBundle;
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
+ (NSNumberFormatter *)multiCurrencyFormatter:(MIDCurrency)currency;
+ (NSNumberFormatter *)indonesianCurrencyFormatter;
+ (NSDateFormatter *)dateFormatterWithIdentifier:(NSString *)identifier;
@end
