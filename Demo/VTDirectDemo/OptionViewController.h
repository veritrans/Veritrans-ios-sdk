//
//  OptionViewController.h
//  VTDirectDemo
//
//  Created by Nanang Rafsanjani on 3/15/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const kOptionViewControllerCCType = @"cc_payment_type";
static NSString *const kOptionViewControllerCCSecure = @"cc_secure";
static NSString *const kOptionViewControllerCCTokenStorage = @"cc_token_storage";
static NSString *const kOptionViewControllerCCSaveCard = @"cc_save_card";
static NSString *const kOptionViewControllerCCAcquiringBank = @"cc_acquiring_bank";
static NSString *const kOptionViewControllerThemeColor = @"theme_color";
static NSString *const kOptionViewControllerCustomFont = @"custom_font";
static NSString *const kOptionViewControllerAcquiringBank = @"acquiring_bank";
static NSString *const kOptionViewControllerPromoEngine = @"cc_promo_engine";
static NSString *const kOptionViewControllerPreauth = @"cc_preauth";

@interface OptionViewController : UIViewController

@end
