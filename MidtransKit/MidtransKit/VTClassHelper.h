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

#import <MidtransCoreKit/VTHelper.h>

@interface VTClassHelper : UIViewController
+ (NSBundle*)kitBundle;
@end

@interface NSNumber (formatter)
- (NSString *)formattedCurrencyNumber;
@end

@interface NSString (utilities)
- (BOOL)isNumeric;
- (NSString *)formattedCreditCardNumber;
@end

@interface UITextField (helper)

- (BOOL)filterNumericWithString:(NSString *)string range:(NSRange)range length:(NSInteger)length;
- (BOOL)filterCvvNumber:(NSString *)string range:(NSRange)range withCardNumber:(NSString *)cardNumber;
- (BOOL)filterCreditCardExpiryDate:(NSString *)string range:(NSRange)range;
- (BOOL)filterCreditCardWithString:(NSString *)string range:(NSRange)range;

@end

@interface UILabel (utilities)
- (void)setRoundedCorners:(BOOL)rounded;
@end

@interface UIViewController (Utils)
- (void)addSubViewController:(UIViewController *)viewController toView:(UIView*)contentView;
- (void)removeSubViewController:(UIViewController *)viewController;
@end
