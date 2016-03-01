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

extern NSString *const VTPaymentCreditCard;
extern NSString *const VTPaymentPermataVA;
extern NSString *const VTPaymentMandiriClickpay;
extern NSString *const VTPaymentBCAVA;
extern NSString *const VTPaymentMandiriBillpay;
extern NSString *const VTPaymentCIMBClicks;
extern NSString *const VTPaymentBCAKlikpay;
extern NSString *const VTPaymentIndomaret;
extern NSString *const VTPaymentMandiriECash;

@interface VTClassHelper : UIViewController
+ (NSBundle*)kitBundle;
@end

@interface NSString (utilities)
- (BOOL)isNumeric;
@end

@interface UITextField (helper)

- (BOOL)filterCreditCardExpiryDate:(NSString *)string range:(NSRange)range;

@end

@interface UILabel (utilities)
- (void)setRoundedCorners:(BOOL)rounded;
@end

@interface NSObject (utilities)
+ (NSNumberFormatter *)numberFormatterWith:(NSString *)identifier;
@end