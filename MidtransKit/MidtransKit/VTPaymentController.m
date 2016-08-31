//
//  VTPaymentController.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 5/11/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTPaymentController.h"
#import "VTClassHelper.h"
#import "VTHudView.h"
#import "VTToast.h"
#import "VTKeyboardAccessoryView.h"
#import "VTMultiGuideController.h"
#import "VTSingleGuideController.h"
#import "VTXLTunaiSuccessController.h"
#import "VTThemeManager.h"
#import "VTKITConstant.h"

@interface VTPaymentController ()
@property (nonatomic) VTHudView *hudView;
@property (nonatomic) VTKeyboardAccessoryView *keyboardAccessoryView;
@end

@implementation VTPaymentController

-(instancetype)initWithToken:(TransactionTokenResponse *)token {
    self = [[[self class] alloc] initWithNibName:NSStringFromClass([self class]) bundle:VTBundle];
    if (self) {
        self.token = token;
    }
    return self;
}

-(instancetype)initWithToken:(TransactionTokenResponse *)token paymentMethodName:(VTPaymentListModel *)paymentMethod {
    self = [[[self class] alloc] initWithNibName:NSStringFromClass([self class]) bundle:VTBundle];
    if (self) {
        self.token = token;
        self.paymentMethod = paymentMethod;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.hudView = [[VTHudView alloc] init];
}
-(void)showAlertViewWithTitle:(NSString *)title
                   andMessage:(NSString *)message
               andButtonTitle:(NSString *)buttonTitle {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:buttonTitle otherButtonTitles:nil];
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
- (void)showLoadingHud {
    [self.hudView showOnView:self.navigationController.view];
}

- (void)hideLoadingHud {
    [self.hudView hide];
}

- (void)handleTransactionError:(NSError *)error {
    VTErrorStatusController *vc = [[VTErrorStatusController alloc] initWithError:error];
    if ([VTClassHelper hasKindOfController:vc onControllers:self.navigationController.viewControllers] == NO) {
        [self.navigationController pushViewController:(UIViewController *)vc animated:YES];
    }
}

- (void)handleTransactionPending:(VTTransactionResult *)result {
    NSDictionary *userInfo = @{TRANSACTION_RESULT_KEY:result};
    [[NSNotificationCenter defaultCenter] postNotificationName:TRANSACTION_PENDING object:nil userInfo:userInfo];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)handleTransactionSuccess:(VTTransactionResult *)result {
    UIViewController *vc;
    
    if ([result.transactionStatus isEqualToString:VT_TRANSACTION_STATUS_DENY]) {
        NSError *error = [[NSError alloc] initWithDomain:VT_ERROR_DOMAIN
                                                    code:result.statusCode
                                                userInfo:@{NSLocalizedDescriptionKey:result.statusMessage}];
        vc = [[VTErrorStatusController alloc] initWithError:error];
    }
    else {
        if ([self.paymentMethod.internalBaseClassIdentifier isEqualToString:VT_PAYMENT_XL_TUNAI]) {
            VTPaymentStatusXLTunaiViewModel *viewModel = [[VTPaymentStatusXLTunaiViewModel alloc] initWithTransactionResult:result];
            vc = [[VTXLTunaiSuccessController alloc] initWithToken:self.token paymentMethodName:self.paymentMethod statusModel:viewModel];
        }
        else {
            VTPaymentStatusViewModel *vm = [[VTPaymentStatusViewModel alloc] initWithTransactionResult:result];
            vc = [[VTSuccessStatusController alloc] initWithSuccessViewModel:vm];
        }
    }
    
    if ([VTClassHelper hasKindOfController:vc onControllers:self.navigationController.viewControllers] == NO) {
        [self.navigationController pushViewController:(UIViewController *)vc animated:YES];
    }
}

- (void)showGuideViewController {
    if ([self.paymentMethod.internalBaseClassIdentifier isEqualToString:VT_VA_BCA_IDENTIFIER] ||
        [self.paymentMethod.internalBaseClassIdentifier isEqualToString:VT_VA_MANDIRI_IDENTIFIER] ||
        [self.paymentMethod.internalBaseClassIdentifier isEqualToString:VT_VA_PERMATA_IDENTIFIER] ||
        [self.paymentMethod.internalBaseClassIdentifier isEqualToString:VT_VA_OTHER_IDENTIFIER]) {
        VTMultiGuideController *vc = [[VTMultiGuideController alloc] initWithPaymentMethodModel:self.paymentMethod];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else {
        VTSingleGuideController *vc = [[VTSingleGuideController alloc] initWithPaymentMethodModel:self.paymentMethod];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
-(void)showToastInviewWithMessage:(NSString *)message {
    [VTToast createToast:@"Copied to clipboard" duration:1.5 containerView:self.view];
}
@end
