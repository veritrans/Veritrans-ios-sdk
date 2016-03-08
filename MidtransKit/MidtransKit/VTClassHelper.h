//
//  VTClassHelper.h
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 2/23/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#define VTBundle [VTClassHelper kitBundle]

#import <MidtransCoreKit/VTHelper.h>

typedef NS_ENUM(NSUInteger, VTVAType) {
    VTVATypeBCA,
    VTVATypeMandiri,
    VTVATypePermata,
    VTVATypeOther
};


extern NSString *const VTCreditCardIdentifier;

extern NSString *const VTMandiriClickpayIdentifier;
extern NSString *const VTCIMBClicksIdentifier;
extern NSString *const VTBCAKlikpayIdentifier;
extern NSString *const VTBRIEpayIdentifier;

extern NSString *const VTIndomaretIdentifier;

extern NSString *const VTMandiriECashIdentifier;
extern NSString *const VTBBMIdentifier;
extern NSString *const VTIndosatDompetkuIdentifier;
extern NSString *const VTTCashIdentifier;
extern NSString *const VTXLTunaiIdentifier;

extern NSString *const VTVAIdentifier;
extern NSString *const VTPermataVAIdentifier;
extern NSString *const VTBCAVAIdentifier;
extern NSString *const VTMandiriVAIdentifier;
extern NSString *const VTOtherVAIdentifier;


@interface VTClassHelper : UIViewController
+ (NSBundle*)kitBundle;
@end

@interface NSString (utilities)
- (BOOL)isNumeric;
@end

@interface UITextField (helper)

- (BOOL)filterCvvNumber:(NSString *)string range:(NSRange)range ;
- (BOOL)filterCreditCardExpiryDate:(NSString *)string range:(NSRange)range;
- (BOOL)filterCreditCardWithString:(NSString *)string range:(NSRange)range;

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
