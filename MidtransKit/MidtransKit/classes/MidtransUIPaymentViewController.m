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
#import "MIDV2PaymentListViewController.h"
#import "VTClassHelper.h"
#import "MidtransUIThemeManager.h"
#import "VTKITConstant.h"

@implementation MidtransUIPaymentViewController

@dynamic delegate;

- (instancetype)initWithToken:(MidtransTransactionTokenResponse *)token {
    VTPaymentListController *vc = [[VTPaymentListController alloc] initWithToken:token paymentMethodName:nil];
    self = [[MidtransUIPaymentViewController alloc] initWithRootViewController:vc];
    vc.paymentMethodSelected = nil;
    self.modalPresentationStyle = UIModalPresentationFullScreen;
    return self;
}
- (instancetype)initCreditCardForm {
    VTPaymentListController *vc = [[VTPaymentListController alloc] initWithToken:nil paymentMethodName:nil];
    vc.paymentMethodSelected = MIDTRANS_CREDIT_CARD_FORM;
    self = [[MidtransUIPaymentViewController alloc] initWithRootViewController:vc];
    self.modalPresentationStyle = UIModalPresentationFullScreen;
    return self;

}
- (instancetype)initWithToken:(MidtransTransactionTokenResponse *)token andPaymentFeature:(MidtransPaymentFeature)paymentFeature {
    NSString *paymentMethodSelected;
    switch (paymentFeature) {
        case MidtransPaymentFeatureCreditCard:
            paymentMethodSelected = MIDTRANS_PAYMENT_CREDIT_CARD;
            break;
        case MidtransPaymentFeatureGOPAY:
            paymentMethodSelected = MIDTRANS_PAYMENT_GOPAY;
            break;
        case MidtransPaymentFeatureShopeePay:
            paymentMethodSelected = MIDTRANS_PAYMENT_SHOPEEPAY;
            break;
        case MidtransPaymentFeatureBankTransfer:
            paymentMethodSelected = MIDTRANS_PAYMENT_BANK_TRANSFER;
            break;
        case MidtransPaymentFeatureKlikBCA:
            paymentMethodSelected = MIDTRANS_PAYMENT_KLIK_BCA;
            break;
        case MidtransPaymentFeatureBCAKlikPay:
            paymentMethodSelected = MIDTRANS_PAYMENT_BCA_KLIKPAY;
            break;
        case  MidtransPaymentFeatureCIMBClicks:
            paymentMethodSelected = MIDTRANS_PAYMENT_CIMB_CLICKS;
            break;
        case MidtransPaymentFeatureIndomaret:
            paymentMethodSelected = MIDTRANS_PAYMENT_INDOMARET;
            break;
        case MidtransPaymentFeatureAlfamart:
            paymentMethodSelected = MIDTRANS_PAYMENT_ALFAMART;
            break;
        case MidtransPaymentFeatureDanamonOnline:
            paymentMethodSelected = MIDTRANS_PAYMENT_DANAMON_ONLINE;
            break;
        case MidtransPaymentFeatureBRIEpay:
            paymentMethodSelected = MIDTRANS_PAYMENT_BRI_EPAY;
            break;
        case MidtransPaymentFeatureAkulaku:
            paymentMethodSelected = MIDTRANS_PAYMENT_AKULAKU;
            break;
        case MidtransPaymentFeatureBankTransferMandiriVA:
            paymentMethodSelected = MIDTRANS_PAYMENT_ECHANNEL;
            break;
        case MidtransPaymentFeatureBankTransferPermataVA:
            paymentMethodSelected = MIDTRANS_PAYMENT_PERMATA_VA;
            break;
        case MidtransPaymentFeatureBankTransferBNIVA:
            paymentMethodSelected = MIDTRANS_PAYMENT_BNI_VA;
            break;
        case MidtransPaymentFeatureBankTransferBRIVA:
            paymentMethodSelected = MIDTRANS_PAYMENT_BRI_VA;
            break;
        case MidtransPaymentFeatureBankTransferBCAVA:
            paymentMethodSelected = MIDTRANS_PAYMENT_BCA_VA;
            break;
        case MidtransPaymentFeatureBankTransferOtherVA:
            paymentMethodSelected = MIDTRANS_PAYMENT_OTHER_VA;
            break;
        case MidtransPaymentFeatureUOB:
            paymentMethodSelected = MIDTRANS_PAYMENT_UOB;
            break;
        default:
            paymentMethodSelected = nil;
            break;
    }
    
    VTPaymentListController *vc = [[VTPaymentListController alloc] initWithToken:token paymentMethodName:nil];
    vc.paymentMethodSelected = paymentMethodSelected;
    self = [[MidtransUIPaymentViewController alloc] initWithRootViewController:vc];
    self.modalPresentationStyle = UIModalPresentationFullScreen;
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    if ([[MidtransConfig shared] environment]!=MidtransServerEnvironmentProduction) {
        UIWindow *currentWindow = [UIApplication sharedApplication].keyWindow;
        
        UIImage *image = [UIImage imageNamed:@"test_badge" inBundle:VTBundle compatibleWithTraitCollection:nil];
        UIImageView *badgeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, [currentWindow bounds].size.height-115, 115, 115)];
        badgeImageView.tag =100101;
        badgeImageView.image = image;
        
        [currentWindow addSubview:badgeImageView];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(transactionSuccess:) name:TRANSACTION_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(transactionFailed:) name:TRANSACTION_FAILED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(transactionDeny:) name:TRANSACTION_DENY object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(transactionPending:) name:TRANSACTION_PENDING object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(transactionCanceled:) name:TRANSACTION_CANCELED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveCardSuccess:) name:SAVE_CARD_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveCardFailed:) name:SAVE_CARD_FAILED object:nil];
    
}
- (void)saveCardSuccess:(NSNotification *)sender {
    [self dismissDemoBadge];
    if ([self.paymentDelegate respondsToSelector:@selector(paymentViewController:saveCard:)]) {
        [self.paymentDelegate paymentViewController:self saveCard:sender.userInfo[TRANSACTION_RESULT_KEY]];
    }
}

- (void)setupNavigationBar {
    self.navigationBar.translucent = NO;
    [self.navigationBar setBackgroundImage:[UIImage new]
                            forBarPosition:UIBarPositionAny
                                barMetrics:UIBarMetricsDefault];
    [self.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:[[UIImage alloc] init]];
    self.navigationBar.tintColor = [[MidtransUIThemeManager shared] themeColor];
    
    if (@available(iOS 15.0, *)) {
        self.navigationBar.backgroundColor = [UIColor whiteColor];
        self.navigationBar.titleTextAttributes = @{NSFontAttributeName:[[MidtransUIThemeManager shared].themeFont fontRegularWithSize:17],
                                                   NSForegroundColorAttributeName:[UIColor colorWithRed:3/255. green:3/255. blue:3/255. alpha:1]};
        UIView * statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, [[UIApplication sharedApplication] statusBarFrame].size.height)];
        statusBarView.backgroundColor = [UIColor whiteColor];
        statusBarView.tag = MIDTRANS_UI_PAYMENT_STATUS_BAR_TAG;
        [self.view addSubview:statusBarView];
    } else {
        self.navigationBar.titleTextAttributes = @{NSFontAttributeName:[[MidtransUIThemeManager shared].themeFont fontRegularWithSize:17],
                                                   NSForegroundColorAttributeName:[UIColor colorWithRed:3/255. green:3/255. blue:3/255. alpha:1]};
        self.navigationBar.barTintColor = [UIColor whiteColor];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    if (@available(iOS 13.0, *)) {
        return UIStatusBarStyleDarkContent;
    } else {
        return UIStatusBarStyleDefault;
    }
}

- (void)saveCardFailed:(NSNotification *)sender {
    [self dismissDemoBadge];
    if ([self.paymentDelegate respondsToSelector:@selector(paymentViewController:saveCardFailed:)]) {
        [self.paymentDelegate paymentViewController:self saveCard:sender.userInfo[TRANSACTION_RESULT_KEY]];
    }
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)transactionPending:(NSNotification *)sender {
    [self dismissDemoBadge];
    if ([self.paymentDelegate respondsToSelector:@selector(paymentViewController:paymentPending:)]) {
        [self.paymentDelegate paymentViewController:self paymentPending:sender.userInfo[TRANSACTION_RESULT_KEY]];
    }
}

- (void)transactionDeny:(NSNotification *)sender {
    [self dismissDemoBadge];
    if ([self.paymentDelegate respondsToSelector:@selector(paymentViewController:paymentDeny:)]) {
        [self.paymentDelegate paymentViewController:self paymentDeny:sender.userInfo[TRANSACTION_RESULT_KEY]];
    }
}

- (void)transactionCanceled:(NSNotification *)sender {
  
    if ([self.paymentDelegate respondsToSelector:@selector(paymentViewController_paymentCanceled:)]) {
        [self.paymentDelegate paymentViewController_paymentCanceled:self];
    }
      [self dismissDemoBadge];
}

- (void)transactionSuccess:(NSNotification *)sender {
    [self dismissDemoBadge];
    if ([self.paymentDelegate respondsToSelector:@selector(paymentViewController:paymentSuccess:)]) {
        [self.paymentDelegate paymentViewController:self paymentSuccess:sender.userInfo[TRANSACTION_RESULT_KEY]];
    }
}

- (void)transactionFailed:(NSNotification *)sender {
    [self dismissDemoBadge];
    if ([self.paymentDelegate respondsToSelector:@selector(paymentViewController:paymentFailed:)]) {
        [self.paymentDelegate paymentViewController:self paymentFailed:sender.userInfo[TRANSACTION_ERROR_KEY]];
    }
}
- (void)dismissDemoBadge {
    UIWindow *currentWindow = [UIApplication sharedApplication].keyWindow;
    if ([currentWindow viewWithTag:100101]) {
        [[currentWindow viewWithTag:100101] removeFromSuperview];
    }
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotate {
    return NO;
}
@end
