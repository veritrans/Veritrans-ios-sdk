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
#import "MidtransTransactionDetailViewController.h"
#import "MIdtransUIBorderedView.h"
#import "MidtransUINextStepButton.h"
#import "MidtransUIThemeManager.h"
#import "MIDWebPaymentController.h"

#import "MIDVendorUI.h"

@interface MidtransUIPaymentGeneralViewController () <MIDWebPaymentControllerDelegate, MIDWebPaymentControllerDataSource>
@property (strong, nonatomic) IBOutlet MidtransUIPaymentGeneralView *view;
@property (nonatomic) MidtransPaymentListModel *model;
@end

@implementation MidtransUIPaymentGeneralViewController
@dynamic view;

- (instancetype)initWithModel:(MidtransPaymentListModel *)model {
    if (self = [super init]) {
        self.model = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.model.title;
    self.view.tokenViewConstraints.constant = 0.0f;
    self.view.topConstraints.constant = 0.0f;
    if ([self.model.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_BRI_EPAY] ||
        [self.model.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_BCA_KLIKPAY]) {
        if ([self.model.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_BCA_KLIKPAY]) {
            self.view.tokenViewLabel.text = [VTClassHelper getTranslationFromAppBundleForString:@"SMS Charges may be applied for this payment method"];
            [self.view.tokenViewIcon setImage:[[UIImage imageNamed:@"sms" inBundle:VTBundle compatibleWithTraitCollection:nil] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        }
        self.view.topConstraints.constant = 40.0f;
        self.view.tokenView.hidden = NO;
        self.view.tokenViewConstraints.constant = 40.0f;
        [self updateViewConstraints];
    }
    [self updateViewConstraints];
    NSString *filenameByLanguage = [[MidtransDeviceHelper deviceCurrentLanguage] stringByAppendingFormat:@"_%@", self.model.internalBaseClassIdentifier];
    NSString *guidePath = [VTBundle pathForResource:filenameByLanguage ofType:@"plist"];
    if (guidePath == nil) {
        guidePath = [VTBundle pathForResource:[NSString stringWithFormat:@"en_%@",self.model.internalBaseClassIdentifier] ofType:@"plist"];
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
    
    NSString *snapToken = [MIDVendorUI shared].snapToken;
    
    if ([self.model.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_BCA_KLIKPAY]) {
        [MIDDirectDebitCharge bcaKlikPayWithToken:snapToken completion:^(MIDWebPaymentResult * _Nullable result, NSError * _Nullable error) {
            [self handlePaymentCompletion:result error:error];
        }];
        
    }
    else if ([self.model.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_MANDIRI_ECASH]) {
        [MIDEWalletCharge mandiriECashWithToken:snapToken completion:^(MIDWebPaymentResult * _Nullable result, NSError * _Nullable error) {
            [self handlePaymentCompletion:result error:error];
        }];
        
    }
    else if ([self.model.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_BRI_EPAY]) {
        [MIDDirectDebitCharge briEpayWithToken:snapToken completion:^(MIDWebPaymentResult * _Nullable result, NSError * _Nullable error) {
            [self handlePaymentCompletion:result error:error];
        }];
        
    }
    else if ([self.model.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_AKULAKU]) {
        [MIDCardlessCreditCharge akulakuWithToken:snapToken completion:^(MIDWebPaymentResult * _Nullable result, NSError * _Nullable error) {
            [self handlePaymentCompletion:result error:error];
        }];
        
    }
    else if ([self.model.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_CIMB_CLICKS]) {
        [MIDDirectDebitCharge cimbClicksWithToken:snapToken completion:^(MIDWebPaymentResult * _Nullable result, NSError * _Nullable error) {
            [self handlePaymentCompletion:result error:error];
        }];
        
    }
    else if ([self.model.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_DANAMON_ONLINE]) {
        [MIDDirectDebitCharge danamonOnlineWithToken:snapToken completion:^(MIDWebPaymentResult * _Nullable result, NSError * _Nullable error) {
            [self handlePaymentCompletion:result error:error];
        }];
        
    }
}

- (void)handlePaymentCompletion:(MIDWebPaymentResult *)result error:(NSError *)error {
    [self hideLoading];
    
    if (error) {
        [self handleTransactionError:error];
    }
    else {
        if (result.redirectURL) {
            MIDWebPaymentController *vc = [MIDWebPaymentController new];
            vc.delegate = self;
            vc.dataSource = self;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else {
            [self handleTransactionSuccess:result];
        }
    }
}

#pragma mark - MIDWebPaymentControllerDelegate

- (void)webPaymentController:(MIDWebPaymentController *)viewController didError:(NSError *)error {
    
}

- (void)webPaymentControllerDidPending:(MIDWebPaymentController *)viewController {
    
}

//- (void)webPaymentController_transactionFinished:(MidtransPaymentWebController *)webPaymentController {
//    [super handleTransactionSuccess:webPaymentController.result];
//}
//
//- (void)webPaymentController_transactionPending:(MidtransPaymentWebController *)webPaymentController {
//    [self handleTransactionPending:webPaymentController.result];
//}
//
//- (void)webPaymentController:(MidtransPaymentWebController *)webPaymentController transactionError:(NSError *)error {
//    [self handleTransactionError:error];
//}

#pragma mark - MIDWebPaymentControllerDataSource

- (NSString *)headerTitle {
    
}

- (NSString *)paymentURL {
    
}

- (NSString *)finishedSignText {
    
}

@end
