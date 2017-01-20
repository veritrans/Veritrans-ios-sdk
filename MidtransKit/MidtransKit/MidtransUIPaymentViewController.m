//
//  VTPaymentViewController.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 2/25/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <CoreText/CoreText.h>
#import <MidtransCoreKit/MidtransCoreKit.h>
#import "MidtransUIPaymentViewController.h"
#import "VTPaymentListController.h"
#import "VTClassHelper.h"
#import "MidtransUIThemeManager.h"
#import "VTKITConstant.h"

@implementation MidtransUIPaymentViewController

@dynamic delegate;

- (instancetype)initWithToken:(MidtransTransactionTokenResponse *)token {
    VTPaymentListController *vc = [[VTPaymentListController alloc] initWithToken:token];
    self = [[MidtransUIPaymentViewController alloc] initWithRootViewController:vc];
    return self;
}
- (instancetype)initWithToken:(MidtransTransactionTokenResponse *)token andPaymentFeature:(MidtransPaymentFeature)paymentFeature {
    /*
     static NSString * const MIDTRANS_PAYMENT_BCA_KLIKPAY = @"bca_klikpay";
     static NSString * const MIDTRANS_PAYMENT_KLIK_BCA = @"bca_klikbca";
     static NSString * const MIDTRANS_PAYMENT_INDOMARET = @"indomaret";
     static NSString * const MIDTRANS_PAYMENT_CIMB_CLICKS = @"cimb_clicks";
     static NSString * const MIDTRANS_PAYMENT_CSTORE = @"cstore";
     static NSString * const MIDTRANS_PAYMENT_MANDIRI_ECASH = @"mandiri_ecash";
     static NSString * const MIDTRANS_PAYMENT_CREDIT_CARD = @"credit_card";
     
     static NSString * const MIDTRANS_PAYMENT_ECHANNEL = @"echannel";
     static NSString * const MIDTRANS_PAYMENT_PERMATA_VA = @"permata_va";
     static NSString * const MIDTRANS_PAYMENT_BCA_VA = @"bca_va";
     static NSString * const MIDTRANS_PAYMENT_ALL_VA = @"all_va";
     static NSString * const MIDTRANS_PAYMENT_OTHER_VA= @"other_va";
     static NSString * const MIDTRANS_PAYMENT_VA = @"va";
     
     static NSString * const MIDTRANS_PAYMENT_BRI_EPAY = @"bri_epay";
     static NSString * const MIDTRANS_PAYMENT_TELKOMSEL_CASH = @"telkomsel_cash";
     static NSString * const MIDTRANS_PAYMENT_INDOSAT_DOMPETKU = @"indosat_dompetku";
     static NSString * const MIDTRANS_PAYMENT_XL_TUNAI = @"xl_tunai";
     static NSString * const MIDTRANS_PAYMENT_MANDIRI_CLICKPAY = @"mandiri_clickpay";
     static NSString * const MIDTRANS_PAYMENT_KIOS_ON = @"kioson";
     */
    /*
     MidtransPaymentFeatureCreditCard,
     MidtransPaymentFeatureBankTransfer,///va
     MidtransPaymentFeatureKlikBCA,
     MidtransPaymentFeatureIndomaret,
     MidtransPaymentFeatureCIMBClicks,
     MidtransPaymentFeatureCStore,
     MidtransPaymentFeatureMandiriEcash,
     MidtransPaymentFeatureEchannel,
     MidtransPaymentFeaturePermataVA,
     MidtransPaymentFeatureBRIEpay,
     MidtransPaymentFeatureTelkomselEcash,
     MidtransPaymentFeatureIndosatDompetku,
     MidtransPaymentFeatureXLTunai,
     MidtransPaymentFeatureMandiriClickPay,
     MidtransPaymentFeatureKiosON
     */
    NSString *paymentMethodSelected;
    switch (paymentFeature) {
        case MidtransPaymentFeatureCreditCard:
            paymentMethodSelected = MIDTRANS_PAYMENT_CREDIT_CARD;
            break;
        default:
            break;
    }
    VTPaymentListController *vc = [[VTPaymentListController alloc] initWithToken:token];
    vc.paymentMethodSelected = paymentMethodSelected;
    self = [[MidtransUIPaymentViewController alloc] initWithRootViewController:vc];
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.translucent = false;
    // to remove 1 px border below nav bar
    
    [self.navigationBar setBackgroundImage:[UIImage new]
                            forBarPosition:UIBarPositionAny
                                barMetrics:UIBarMetricsDefault];
    [self.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationBar setShadowImage:[[UIImage alloc] init]];
    self.navigationBar.tintColor = [[MidtransUIThemeManager shared] themeColor];
    self.navigationBar.titleTextAttributes = @{NSFontAttributeName:[[MidtransUIThemeManager shared].themeFont fontRegularWithSize:17], NSForegroundColorAttributeName:[UIColor colorWithRed:3/255. green:3/255. blue:3/255. alpha:1]};
    self.navigationBar.barTintColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(transactionSuccess:) name:TRANSACTION_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(transactionFailed:) name:TRANSACTION_FAILED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(transactionPending:) name:TRANSACTION_PENDING object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(transactionCanceled:) name:TRANSACTION_CANCELED object:nil];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)transactionPending:(NSNotification *)sender {
    if ([self.paymentDelegate respondsToSelector:@selector(paymentViewController:paymentPending:)]) {
        [self.paymentDelegate paymentViewController:self paymentPending:sender.userInfo[TRANSACTION_RESULT_KEY]];
    }
}

- (void)transactionCanceled:(NSNotification *)sender {
    if ([self.paymentDelegate respondsToSelector:@selector(paymentViewController_paymentCanceled:)]) {
        [self.paymentDelegate paymentViewController_paymentCanceled:self];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)transactionSuccess:(NSNotification *)sender {
    if ([self.paymentDelegate respondsToSelector:@selector(paymentViewController:paymentSuccess:)]) {
        [self.paymentDelegate paymentViewController:self paymentSuccess:sender.userInfo[TRANSACTION_RESULT_KEY]];
    }
}

- (void)transactionFailed:(NSNotification *)sender {
    if ([self.paymentDelegate respondsToSelector:@selector(paymentViewController:paymentFailed:)]) {
        [self.paymentDelegate paymentViewController:self paymentFailed:sender.userInfo[TRANSACTION_ERROR_KEY]];
    }
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotate {
    return NO;
}
@end
