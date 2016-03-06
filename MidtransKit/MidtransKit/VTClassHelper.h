//
//  VTClassHelper.h
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 2/23/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#define VTBundle [VTClassHelper kitBundle]

#import <UIKit/UIKit.h>
#import <MidtransCoreKit/VTHelper.h>

extern NSString *const VTCreditCardIdentifier;
extern NSString *const VTPermataVAIdentifier;
extern NSString *const VTMandiriClickpayIdentifier;
extern NSString *const VTBCAVAIdentifier;
extern NSString *const VTMandiriBillpayIdentifier;
extern NSString *const VTCIMBClicksIdentifier;
extern NSString *const VTBCAKlikpayIdentifier;
extern NSString *const VTIndomaretIdentifier;
extern NSString *const VTMandiriECashIdentifier;

@interface VTClassHelper : UIViewController
+ (NSBundle*)kitBundle;
@end

@interface NSString (utilities)
- (BOOL)isNumeric;
@end

@interface UITextField (helper)

- (BOOL)filterCvvNumber:(NSString *)string range:(NSRange)range ;
- (BOOL)filterCreditCardExpiryDate:(NSString *)string range:(NSRange)range;

@end

@interface UILabel (utilities)
- (void)setRoundedCorners:(BOOL)rounded;
@end

@interface NSObject (utilities)
+ (NSNumberFormatter *)numberFormatterWith:(NSString *)identifier;
@end

@interface UIViewController (Utils)
- (void)addSubViewController:(UIViewController *)viewController toView:(UIView*)contentView;
- (void)removeSubViewController:(UIViewController *)viewController;
@end

@interface UIApplication (utilities)
+ (UIViewController *)rootViewController;
@end