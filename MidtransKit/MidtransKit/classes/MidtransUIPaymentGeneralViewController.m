//
//  VTPaymentGeneralViewController.m
//  MidtransKit
//
//  Created by Arie on 6/18/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MidtransUIPaymentGeneralViewController.h"
#import "MidtransUIPaymentGeneralView.h"
#import "VTClassHelper.h"
#import "UIViewController+HeaderSubtitle.h"
#import "MidtransUIStringHelper.h"
#import <MidtransCoreKit/MidtransCoreKit.h>
#import "MidtransTransactionDetailViewController.h"
#import "MIdtransUIBorderedView.h"
#import "MidtransUINextStepButton.h"
#import "MidtransUIThemeManager.h"

@interface MidtransUIPaymentGeneralViewController () <MidtransPaymentWebControllerDelegate>
@property (strong, nonatomic) IBOutlet MidtransUIPaymentGeneralView *view;
@property (nonatomic) MidtransPaymentRequestV2Merchant *merchant;
@end

@implementation MidtransUIPaymentGeneralViewController
@dynamic view;

- (instancetype)initWithToken:(MidtransTransactionTokenResponse *)token
            paymentMethodName:(MidtransPaymentListModel *)paymentMethod
                     merchant:(MidtransPaymentRequestV2Merchant *)merchant {
    
    if (self = [super initWithToken:token paymentMethodName:paymentMethod]) {
        self.merchant = merchant;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.paymentMethod.title;
    self.view.tokenViewConstraints.constant = 0.0f;
    self.view.topConstraints.constant = 0.0f;
    if ([self.paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_BRI_EPAY]|| [self.paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_BCA_KLIKPAY]) {
        if ([self.paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_BCA_KLIKPAY]) {
            self.view.tokenViewLabel.text = [VTClassHelper getTranslationFromAppBundleForString:@"SMS Charges may be applied for this payment method"];
            [self.view.tokenViewIcon setImage:[[UIImage imageNamed:@"sms" inBundle:VTBundle compatibleWithTraitCollection:nil] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        }
        self.view.topConstraints.constant = 40.0f;
        self.view.tokenView.hidden = NO;
        self.view.tokenViewConstraints.constant = 40.0f;
        [self updateViewConstraints];
    }
    [self updateViewConstraints];
    NSString *filenameByLanguage = [[MidtransDeviceHelper deviceCurrentLanguage] stringByAppendingFormat:@"_%@", self.paymentMethod.internalBaseClassIdentifier];
    NSString *guidePath = [VTBundle pathForResource:filenameByLanguage ofType:@"plist"];
    if (guidePath == nil) {
        guidePath = [VTBundle pathForResource:[NSString stringWithFormat:@"en_%@",self.paymentMethod.internalBaseClassIdentifier] ofType:@"plist"];
    }
    
    NSArray *instructions = [VTClassHelper instructionsFromFilePath:guidePath];
    
    self.view.guideView.instructions = instructions;
    self.view.totalAmountLabel.text = self.token.transactionDetails.grossAmount.formattedCurrencyNumber;
    self.view.orderIdLabel.text = self.token.transactionDetails.orderId;
    [self.view.totalAmountBorderedView addGestureRecognizer:
     [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(totalAmountBorderedViewTapped:)]];
    self.view.totalAmountLabel.textColor = [[MidtransUIThemeManager shared] themeColor];
}
- (void) totalAmountBorderedViewTapped:(id) sender {
    MidtransTransactionDetailViewController *transactionViewController = [[MidtransTransactionDetailViewController alloc] initWithNibName:@"MidtransTransactionDetailViewController" bundle:VTBundle];
    [transactionViewController presentAtPositionOfView:self.view.totalAmountBorderedView items:self.token.itemDetails];
}

- (IBAction)confirmPaymentPressed:(UIButton *)sender {
    [self showLoadingWithText:nil];
    
    id<MidtransPaymentDetails>paymentDetails;
    
    if ([self.paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_BCA_KLIKPAY]) {
        paymentDetails = [[MidtransPaymentBCAKlikpay alloc] init];
    }
    else if ([self.paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_MANDIRI_ECASH]) {
        paymentDetails = [[MidtransPaymentMandiriECash alloc] init];
    }
    else if ([self.paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_BRI_EPAY]) {
        paymentDetails = [[MidtransPaymentEpayBRI alloc] init];
    }
    else if ([self.paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_CIMB_CLICKS]) {
        paymentDetails = [[MidtransPaymentCIMBClicks alloc] init];
    }
    else if ([self.paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_DANAMON_ONLINE]) {
        paymentDetails = [[MidtransPaymentDanamonOnline alloc] init];
    }
    else if ([self.paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_XL_TUNAI]) {
        paymentDetails = [[MidtransPaymentXLTunai alloc] init];
    }
    
    MidtransTransaction *transaction = [[MidtransTransaction alloc] initWithPaymentDetails:paymentDetails token:self.token];
    
    [[MidtransMerchantClient shared] performTransaction:transaction
                                             completion:^(MidtransTransactionResult *result, NSError *error) {
        [self hideLoading];
        if (error) {
            [self handleTransactionError:error];
        }
        else {
            if (result.redirectURL) {
                MidtransPaymentWebController *vc = [[MidtransPaymentWebController alloc] initWithMerchant:self.merchant
                                                                                                   result:result
                                                                                               identifier:self.paymentMethod.internalBaseClassIdentifier];
                vc.delegate = self;
                [self.navigationController pushViewController:vc animated:YES];
            }
            else {
                [self handleTransactionSuccess:result];
            }
        }
    }];
}

#pragma mark - VTPaymentWebControllerDelegate

- (void)webPaymentController_transactionFinished:(MidtransPaymentWebController *)webPaymentController {
    [super handleTransactionSuccess:webPaymentController.result];
}

- (void)webPaymentController_transactionPending:(MidtransPaymentWebController *)webPaymentController {
    [self handleTransactionPending:webPaymentController.result];
}

- (void)webPaymentController:(MidtransPaymentWebController *)webPaymentController transactionError:(NSError *)error {
    [self handleTransactionError:error];
}

@end
