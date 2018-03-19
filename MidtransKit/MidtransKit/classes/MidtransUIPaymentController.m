//
//  VTPaymentController.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 5/11/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MidtransUIPaymentController.h"
#import "MidtransUIPaymentViewController.h"
#import "VTClassHelper.h"
#import "SNPMaintainView.h"
#import "MidtransUIHudView.h"
#import "MidtransUIToast.h"
#import "MidtransPaymentStatusViewController.h"
#import "VTKeyboardAccessoryView.h"
#import "VTMultiGuideController.h"
#import "VTSingleGuideController.h"
#import "VTXLTunaiSuccessController.h"
#import "MidtransUIThemeManager.h"
#import "VTKITConstant.h"
#import "MidtransPaymentStatusViewController.h"
#import "MidtransLoadingView.h"
#import "MidtransUIConfiguration.h"
#import "VTVATransactionStatusViewModel.h"
#import "VTBillpaySuccessController.h"
#import "VTVASuccessStatusController.h"
#import "VTIndomaretSuccessController.h"
#import "VTKlikbcaSuccessController.h"

@interface MidtransUIPaymentController () <SNPMaintainViewDelegate>
@property (nonatomic) VTKeyboardAccessoryView *keyboardAccessoryView;
@property (nonatomic, strong) UIBarButtonItem *backBarButton;
@property (nonatomic) MidtransLoadingView *loadingView;
@property (nonatomic) SNPMaintainView *maintainView;
@property (nonatomic) BOOL dismissButton;

@end

@implementation MidtransUIPaymentController

-(instancetype)initWithToken:(MidtransTransactionTokenResponse *)token paymentMethodName:(MidtransPaymentListModel *)paymentMethod {
    self = [[[self class] alloc] initWithNibName:NSStringFromClass([self class]) bundle:VTBundle];
    if (self) {
        self.token = token;
        self.paymentMethod = paymentMethod;
    }
    return self;
}

-(void)showBackButton:(BOOL)show  {
    if (show) {
        if (!self.backBarButton) {
            UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f,
                                                                              0.0f,
                                                                              24.0f,
                                                                              24.0f)];
            
            UIImage *image = [UIImage imageNamed:@"back" inBundle:VTBundle compatibleWithTraitCollection:nil];
            [backButton setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
                        forState:UIControlStateNormal];
            [backButton addTarget:self
                           action:@selector(backButtonDidTapped:)
                 forControlEvents:UIControlEventTouchUpInside];
            self.backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        }
        
        self.navigationItem.leftBarButtonItem = self.backBarButton;
    }
    else {
        self.navigationItem.leftBarButtonItem = nil;
    }
}
- (void)backButtonDidTapped:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)showDismissButton:(BOOL)show {
    if (show) {
        self.dismissButton = YES;
        if (!self.backBarButton) {
            self.backBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop
                                                                               target:self
                                                                               action:@selector(dismissButtonDidTapped:)];
        }
        self.navigationItem.leftBarButtonItem = self.backBarButton;
    }
    else {
        self.navigationItem.leftBarButtonItem = nil;
    }
}
- (void)dismissButtonDidTapped:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:TRANSACTION_CANCELED object:nil];
    sleep(2);
    if (self.dismissButton) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.navigationController.viewControllers.count > 1) {
        [self showBackButton:YES];
    }
}
-(void)showAlertViewWithTitle:(NSString *)title
                   andMessage:(NSString *)message
               andButtonTitle:(NSString *)buttonTitle {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:buttonTitle
                                          otherButtonTitles:nil];
    [alert show];
}
- (void)addNavigationToTextFields:(NSArray <UITextField*>*)fields {
    _keyboardAccessoryView = [[VTKeyboardAccessoryView alloc] initWithFrame:CGRectZero fields:fields];
}
- (void)showMerchantLogo:(BOOL)merchantLogo {
    if (merchantLogo) {
    }
    else {
        self.title = self.title;
    }
}

-(void)showMaintainViewWithTtitle:(NSString*)title andContent:(NSString *)content andButtonTitle:(NSString *)buttonTitle {
    [self.maintainView showInView:self.navigationController.view withTitle:title andContent:content andButtonTitle:buttonTitle];
    self.maintainView.delegate = self;
}
-(void)hideMaintain {
    [self.maintainView hide];
}
- (void)maintainViewButtonDidTapped:(NSString *)title {
    [self dismissDemoBadge];
    [self.navigationController dismissViewControllerAnimated:YES
                                                  completion:nil];
}
- (void)showLoadingWithText:(NSString *)text {
    [self.loadingView showInView:self.navigationController.view withText:text];
}

- (void)hideLoading {
    [self.loadingView hide];
}

- (SNPMaintainView *)maintainView {
    if (!_maintainView) {
        _maintainView = [VTBundle loadNibNamed:@"SNPMaintainView" owner:self options:nil].firstObject;
    }
    return _maintainView;
}
- (MidtransLoadingView *)loadingView {
    if (!_loadingView) {
        _loadingView = [VTBundle loadNibNamed:@"MidtransLoadingView" owner:self options:nil].firstObject;
    }
    return _loadingView;
}

- (void)handleTransactionError:(NSError *)error {
    if (UICONFIG.hideStatusPage) {
        [self dismissDemoBadge];
        NSDictionary *userInfo = @{TRANSACTION_ERROR_KEY:error};
        [[NSNotificationCenter defaultCenter] postNotificationName:TRANSACTION_FAILED
                                                            object:nil
                                                          userInfo:userInfo];
        
        [self.navigationController dismissViewControllerAnimated:YES
                                                      completion:nil];
        return;
    }
    
    VTPaymentStatusController *vc = [VTPaymentStatusController errorTransactionWithError:error
                                                                                   token:self.token
                                                                           paymentMethod:self.paymentMethod];
    
    if ([VTClassHelper hasKindOfController:vc onControllers:self.navigationController.viewControllers] == NO) {
        [self.navigationController pushViewController:(UIViewController *)vc animated:YES];
    }
}

- (void)handleTransactionResult:(MidtransTransactionResult *)result {
    if (UICONFIG.hideStatusPage) {
        NSDictionary *userInfo = @{TRANSACTION_RESULT_KEY:result};
        [self dismissDemoBadge];
        [[NSNotificationCenter defaultCenter] postNotificationName:TRANSACTION_PENDING object:nil userInfo:userInfo];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    MidtransPaymentStatusViewController *paymentStatusVC = [[MidtransPaymentStatusViewController alloc] initWithTransactionResult:result];
    if ([VTClassHelper hasKindOfController:paymentStatusVC onControllers:self.navigationController.viewControllers] == NO) {
        [self.navigationController pushViewController:(UIViewController *)paymentStatusVC animated:YES];
    }
}
- (void)handleTransactionPending:(MidtransTransactionResult *)result {
    NSDictionary *userInfo = @{TRANSACTION_RESULT_KEY:result};
    [self dismissDemoBadge];
    [[NSNotificationCenter defaultCenter] postNotificationName:TRANSACTION_PENDING object:nil userInfo:userInfo];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (void)handleSaveCardSuccess:(MidtransMaskedCreditCard *)result {
    NSDictionary *userInfo = @{TRANSACTION_RESULT_KEY:result};
    [[NSNotificationCenter defaultCenter] postNotificationName:SAVE_CARD_SUCCESS object:nil userInfo:userInfo];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    return;
}
- (void)handleSaveCardError:(NSError *)error {
    NSDictionary *userInfo = @{TRANSACTION_RESULT_KEY:error};
    [[NSNotificationCenter defaultCenter] postNotificationName:SAVE_CARD_FAILED object:nil userInfo:userInfo];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    return;
}
- (void)handleTransactionSuccess:(MidtransTransactionResult *)result {
    if (UICONFIG.hideStatusPage) {
        [self dismissDemoBadge];
        NSDictionary *userInfo = @{TRANSACTION_RESULT_KEY:result};
        [[NSNotificationCenter defaultCenter] postNotificationName:TRANSACTION_SUCCESS object:nil userInfo:userInfo];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    UIViewController *vc;
    if ([result.transactionStatus isEqualToString:MIDTRANS_TRANSACTION_STATUS_DENY]) {
        NSError *error = [[NSError alloc] initWithDomain:MIDTRANS_ERROR_DOMAIN
                                                    code:result.statusCode
                                                userInfo:@{NSLocalizedDescriptionKey:result.statusMessage}];
        vc = [VTPaymentStatusController errorTransactionWithError:error token:self.token paymentMethod:self.paymentMethod];
    }
    else {
        id paymentID = self.paymentMethod.internalBaseClassIdentifier;
        if ([paymentID isEqualToString:MIDTRANS_PAYMENT_BCA_VA] ||
            [paymentID isEqualToString:MIDTRANS_PAYMENT_BNI_VA] ||
            [paymentID isEqualToString:MIDTRANS_PAYMENT_PERMATA_VA] ||
            [paymentID isEqualToString:MIDTRANS_PAYMENT_ALL_VA] ||
            [paymentID isEqualToString:MIDTRANS_PAYMENT_OTHER_VA]) {
            VTVATransactionStatusViewModel *vm = [[VTVATransactionStatusViewModel alloc] initWithTransactionResult:result
                                                                                                 paymentIdentifier:paymentID];
            
            VTVASuccessStatusController *vc = [[VTVASuccessStatusController alloc] initWithToken:self.token
                                                                               paymentMethodName:self.paymentMethod
                                                                                     statusModel:vm];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if ([paymentID isEqualToString:MIDTRANS_PAYMENT_ECHANNEL]) {
            VTVATransactionStatusViewModel *vm = [[VTVATransactionStatusViewModel alloc] initWithTransactionResult:result
                                                                                                 paymentIdentifier:paymentID];
            
            VTBillpaySuccessController *vc = [[VTBillpaySuccessController alloc] initWithToken:self.token
                                                                             paymentMethodName:self.paymentMethod
                                                                                   statusModel:vm];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if ([paymentID isEqualToString:MIDTRANS_PAYMENT_INDOMARET]) {
            VTPaymentStatusViewModel *vm = [[VTPaymentStatusViewModel alloc] initWithTransactionResult:result];
            VTIndomaretSuccessController *vc = [[VTIndomaretSuccessController alloc] initWithToken:self.token
                                                                                 paymentMethodName:self.paymentMethod
                                                                                       statusModel:vm];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if ([paymentID isEqualToString:MIDTRANS_PAYMENT_KLIK_BCA]) {
            VTPaymentStatusViewModel *vm = [[VTPaymentStatusViewModel alloc] initWithTransactionResult:result];
            VTKlikbcaSuccessController *vc = [[VTKlikbcaSuccessController alloc] initWithToken:self.token
                                                                             paymentMethodName:self.paymentMethod
                                                                                     viewModel:vm];
            
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if ([paymentID isEqualToString:MIDTRANS_PAYMENT_KIOS_ON]) {
            VTPaymentStatusController *vc = [VTPaymentStatusController pendingTransactionWithResult:result
                                                                                              token:self.token
                                                                                      paymentMethod:self.paymentMethod];
            
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if ([paymentID isEqualToString:MIDTRANS_PAYMENT_XL_TUNAI]) {
            VTPaymentStatusXLTunaiViewModel *viewModel = [[VTPaymentStatusXLTunaiViewModel alloc] initWithTransactionResult:result];
            vc = [[VTXLTunaiSuccessController alloc] initWithToken:self.token
                                                 paymentMethodName:self.paymentMethod
                                                       statusModel:viewModel];
        }
        else {
            vc = [VTPaymentStatusController successTransactionWithResult:result
                                                                   token:self.token
                                                           paymentMethod:self.paymentMethod];
        }
    }
    if ([VTClassHelper hasKindOfController:vc onControllers:self.navigationController.viewControllers] == NO) {
        [self.navigationController pushViewController:(UIViewController *)vc animated:YES];
    }
}
- (void)dismissDemoBadge {
    UIWindow *currentWindow = [UIApplication sharedApplication].keyWindow;
    if ([currentWindow viewWithTag:100101]) {
        [[currentWindow viewWithTag:100101] removeFromSuperview];
    }
    
}
- (void)showGuideViewController {
    id paymentID = self.paymentMethod.internalBaseClassIdentifier;
    if ([paymentID isEqualToString:MIDTRANS_PAYMENT_BCA_VA] ||
        [paymentID isEqualToString:MIDTRANS_PAYMENT_ECHANNEL] ||
        [paymentID isEqualToString:MIDTRANS_PAYMENT_PERMATA_VA] ||
        [paymentID isEqualToString:MIDTRANS_PAYMENT_ALL_VA] || [paymentID isEqualToString:MIDTRANS_PAYMENT_OTHER_VA]) {
        
        [[SNPUITrackingManager shared] trackEventName:[NSString stringWithFormat:@"pg %@ va overview",[self.paymentMethod.title lowercaseString]]];
        VTMultiGuideController *vc = [[VTMultiGuideController alloc] initWithPaymentMethodModel:self.paymentMethod];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else {
        VTSingleGuideController *vc = [[VTSingleGuideController alloc] initWithPaymentMethodModel:self.paymentMethod];
        [self.navigationController pushViewController:vc animated:YES];
        [[SNPUITrackingManager shared] trackEventName:[NSString stringWithFormat:@"pg %@ overview",self.paymentMethod.shortName]];
    }
}
-(void)showToastInviewWithMessage:(NSString *)message {
    [MidtransUIToast createToast:message?message:@"Copied to clipboard" duration:1.5 containerView:self.view];
}

@end
