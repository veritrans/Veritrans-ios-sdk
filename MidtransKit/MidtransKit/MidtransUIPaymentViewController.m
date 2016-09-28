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

@interface MidtransUIPaymentViewController ()
@end

@implementation MidtransUIPaymentViewController

@dynamic delegate;

- (instancetype)initWithToken:(MidtransTransactionTokenResponse *)token andUsingScanCardMethod:(BOOL)cardScanner {
    VTPaymentListController *vc = [[VTPaymentListController alloc] initWithToken:token];
    [[NSUserDefaults standardUserDefaults] setBool:cardScanner forKey:MIDTRANS_CORE_USING_CREDIT_CARD_SCANNER];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self = [[MidtransUIPaymentViewController alloc] initWithRootViewController:vc];
    return self;
}
- (void)addCardButtonDidTapped {

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
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)transactionPending:(NSNotification *)sender {
    if ([self.delegate respondsToSelector:@selector(paymentViewController:paymentPending:)]) {
        [self.delegate paymentViewController:self paymentPending:sender.userInfo[TRANSACTION_RESULT_KEY]];
    }
}


- (void)transactionSuccess:(NSNotification *)sender {
    if ([self.delegate respondsToSelector:@selector(paymentViewController:paymentSuccess:)]) {
        [self.delegate paymentViewController:self paymentSuccess:sender.userInfo[TRANSACTION_RESULT_KEY]];
    }
}

- (void)transactionFailed:(NSNotification *)sender {
    if ([self.delegate respondsToSelector:@selector(paymentViewController:paymentFailed:)]) {
        [self.delegate paymentViewController:self paymentFailed:sender.userInfo[TRANSACTION_ERROR_KEY]];
    }
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}
- (void)scanCardDidTapped {
    if ([self.delegate respondsToSelector:@selector(addCardButtonDidTapped)]) {
        [self.delegate addCardButtonDidTapped];
    }
}
- (BOOL)shouldAutorotate {
    return NO;
}
@end
