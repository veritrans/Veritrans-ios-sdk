//
//  VTClassHelper.h
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 2/23/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#define VTBundle [VTClassHelper kitBundle]

#define IPHONE_4 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )480 ) < DBL_EPSILON )

#import <MidtransCoreKit/VTHelper.h>

extern NSString *const TRANSACTION_SUCCESS;
extern NSString *const TRANSACTION_FAILED;

extern NSString *const VTCreditCardIdentifier;
extern NSString *const VTVAIdentifier;
extern NSString *const VTPermataVAIdentifier;
extern NSString *const VTBCAVAIdentifier;
extern NSString *const VTMandiriVAIdentifier;
extern NSString *const VTOtherVAIdentifier;
extern NSString *const VTKlikBCAIdentifier;
extern NSString *const VTKlikpayIdentifier;
extern NSString *const VTClickpayIdentifier;
extern NSString *const VTClicksIdentifier;
extern NSString *const VTECashIdentifier;
extern NSString *const VTEpayIdentifier;
extern NSString *const VTTelkomselIdentifier;
extern NSString *const VTIndomaretIdentifier;

@interface VTClassHelper : UIViewController
+ (NSBundle*)kitBundle;
@end

@interface NSString (utilities)
- (BOOL)isNumeric;
- (NSString *)formattedCreditCardNumber;
@end

@interface UITextField (helper)

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
