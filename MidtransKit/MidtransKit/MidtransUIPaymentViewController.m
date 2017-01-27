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
    
    
    if ([CONFIG environment] == MidtransServerEnvironmentSandbox) {
        [[MidtransNetworkLogger shared] startLogging];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)transactionPending:(NSNotification *)sender {
    [[MidtransNetworkLogger shared] stopLogging];
    
    if ([self.paymentDelegate respondsToSelector:@selector(paymentViewController:paymentPending:)]) {
        [self.paymentDelegate paymentViewController:self paymentPending:sender.userInfo[TRANSACTION_RESULT_KEY]];
    }
}

- (void)transactionCanceled:(NSNotification *)sender {
    [[MidtransNetworkLogger shared] stopLogging];
    
    if ([self.paymentDelegate respondsToSelector:@selector(paymentViewController_paymentCanceled:)]) {
        [self.paymentDelegate paymentViewController_paymentCanceled:self];
    }
}

- (void)transactionSuccess:(NSNotification *)sender {
    [[MidtransNetworkLogger shared] stopLogging];
    
    if ([self.paymentDelegate respondsToSelector:@selector(paymentViewController:paymentSuccess:)]) {
        [self.paymentDelegate paymentViewController:self paymentSuccess:sender.userInfo[TRANSACTION_RESULT_KEY]];
    }
}

- (void)transactionFailed:(NSNotification *)sender {
    [[MidtransNetworkLogger shared] stopLogging];
    
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
