//
//  VTClassHelper.h
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 2/23/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#define VTBundle [VTClassHelper kitBundle]

#define UILocalizedString(key, comment) \
[VTBundle localizedStringForKey:(key) value:@"" table:nil]

#define IPHONE_4 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )480 ) < DBL_EPSILON )

#import <MidtransCoreKit/MidtransCoreKit.h>
#import "VTInstruction.h"
#import "VTGroupedInstruction.h"

@interface NSMutableAttributedString (Helper)
- (void)replaceCharacterString:(NSString *)characterString withIcon:(UIImage *)icon;
@end

@interface VTClassHelper : UIViewController
+ (NSBundle*)kitBundle;
+ (NSArray <VTInstruction *> *)instructionsFromFilePath:(NSString *)filePath;
+ (NSArray <VTGroupedInstruction*>*)groupedInstructionsFromFilePath:(NSString *)filePath;
+ (BOOL)hasKindOfController:(UIViewController *)controller onControllers:(NSArray<UIViewController*>*)controllers;
+ (UIViewController *)rootViewController;
@end

@interface NSNumber (formatter)
- (NSString *)formattedCurrencyNumber;
@end

@interface NSString (utilities)
- (BOOL)isNumeric;
- (NSString *)formattedCreditCardNumber;
- (CGSize)sizeWithFont:(UIFont *)font constraint:(CGSize)constraint;
@end

@interface UILabel (utilities)
- (void)setRoundedCorners:(BOOL)rounded;
@end

@interface UIViewController (Utils)
- (void)addSubViewController:(UIViewController *)viewController toView:(UIView*)contentView;
- (void)removeSubViewController:(UIViewController *)viewController;
@end

@interface NSArray (Item)
- (NSString *)formattedPriceAmount;
@end

@interface MidtransMaskedCreditCard (utilities)
- (NSString *)formattedNumber;
- (UIImage *)darkIcon;
@end
