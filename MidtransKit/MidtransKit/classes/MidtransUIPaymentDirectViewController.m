//
//  VTPaymentDirectViewController.m
//  MidtransKit
//
//  Created by Arie on 6/18/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MidtransUIPaymentDirectViewController.h"
#import "MidtransUIPaymentDirectView.h"
#import "MidtransUITextField.h"
#import "MidtransUIButton.h"
#import "SNPPostPaymentGeneralViewController.h"
#import "VTClassHelper.h"
#import "MIdtransUIBorderedView.h"
#import "MidtransTransactionDetailViewController.h"
#import <MidtransCoreKit/MidtransCoreKit.h>
#import "MidtransUIThemeManager.h"
@interface MidtransUIPaymentDirectViewController ()
@property (strong, nonatomic) IBOutlet MidtransUIPaymentDirectView *view;
@property (nonatomic) MidtransVAType paymentType;
@end

@implementation MidtransUIPaymentDirectViewController
@dynamic view;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.paymentMethod.title;
    self.view.topLabelText.text  = [VTClassHelper getTranslationFromAppBundleForString:@"Key token device is required for this payment method"];
    self.view.topConstraints.constant = 0.0f;
    self.view.topViewConstraints.constant = 0.0f;
    if ([self.paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_KLIK_BCA]) {
        self.view.disclosureButtonImage.hidden = YES;
    } else if ([self.paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_KIOS_ON] ||
               [self.paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_BCA_KLIKPAY] ||
               [self.paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_CIMB_CLICKS]  ||
               [self.paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_BRI_EPAY] ||
               [self.paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_INDOMARET] ||
               [self.paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_DANAMON_ONLINE]  ||
               [self.paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_MANDIRI_ECASH] ) {
        self.view.disclosureButtonImage.hidden = YES;
    } else {
        self.view.disclosureButtonImage.hidden = YES;
    }
    [[SNPUITrackingManager shared] trackEventName:[NSString stringWithFormat:@"pg %@",self.paymentMethod.shortName]];
    [self addNavigationToTextFields:@[self.view.emailTextField]];
    self.view.totalAmountLabel.text = self.token.transactionDetails.grossAmount.formattedCurrencyNumber;
    self.view.orderIdLabel.text = self.token.transactionDetails.orderId;
    self.view.instructionTitleLabel.text = [NSString stringWithFormat:[VTClassHelper getTranslationFromAppBundleForString:@"%@ step by step"], self.paymentMethod.title];
    if ([[MidtransDeviceHelper deviceCurrentLanguage] isEqualToString:@"id"]) {
        self.view.instructionTitleLabel.text = [NSString stringWithFormat:@" Panduan pembayaran melalui %@", self.paymentMethod.title];
    }
    [self.view initViewWithPaymentID:self.paymentMethod.internalBaseClassIdentifier email:self.token.customerDetails.email];
    [self.view.totalAmountBorderedView addGestureRecognizer:
     [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(totalAmountBorderedViewTapped:)]];
    self.view.totalAmountLabel.textColor = [[MidtransUIThemeManager shared] themeColor];
}
- (void) totalAmountBorderedViewTapped:(id) sender {
    MidtransTransactionDetailViewController *transactionViewController = [[MidtransTransactionDetailViewController alloc] initWithNibName:@"MidtransTransactionDetailViewController" bundle:VTBundle];
    [transactionViewController presentAtPositionOfView:self.view.totalAmountBorderedView items:self.token.itemDetails];
}
- (void)setPaymentType:(MidtransVAType)paymentType {
    _paymentType = paymentType;
    [self.view.confirmPaymentButton setTitle:[VTClassHelper getTranslationFromAppBundleForString:@"payment.va.confirm_button"] forState:UIControlStateNormal];
}
- (IBAction)confirmPaymentDidTapped:(id)sender {
    [self showLoadingWithText:nil];
    [[SNPUITrackingManager shared] trackEventName:@"btn confirm payment"];
    id<MidtransPaymentDetails> paymentDetails;
    
    if ([self.paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_BCA_VA] ||
        [self.paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_ECHANNEL] ||
        [self.paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_PERMATA_VA] ||
        [self.paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_ALL_VA] ||
        [self.paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_OTHER_VA]) {
        paymentDetails = [[MidtransPaymentBankTransfer alloc] initWithBankTransferType:self.paymentType
                                                                                 email:self.view.emailTextField.text];
        self.token.customerDetails.email = self.view.emailTextField.text;
    }
    else if ([self.paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_KLIK_BCA]) {
        if (self.view.emailTextField.text.length == 0) {
            self.view.emailTextField.warning = [VTClassHelper getTranslationFromAppBundleForString:@"payment.klikbca.userid-warning"];
            [self hideLoading];
            return;
        }
        paymentDetails = [[MidtransPaymentKlikBCA alloc] initWithKlikBCAUserId:self.view.emailTextField.text];
    }
    else if ([self.paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_INDOMARET]) {
        paymentDetails = [[MidtransPaymentIndomaret alloc] init];
        self.token.customerDetails.email = self.view.emailTextField.text;
    }
    else if ([self.paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_INDOSAT_DOMPETKU]) {
        if (self.view.emailTextField.text.length == 0) {
            self.view.emailTextField.warning = [VTClassHelper getTranslationFromAppBundleForString:@"payment.indosat-dompetku.warning"];
            [self hideLoading];
            return;
        }
        paymentDetails = [[MidtransPaymentIndosatDompetku alloc] initWithMSISDN:self.view.emailTextField.text];
    }
    else if ([self.paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_TELKOMSEL_CASH]) {
        if (self.view.emailTextField.text.length == 0) {
            self.view.emailTextField.warning = [VTClassHelper getTranslationFromAppBundleForString:@"payment.telkomsel-cash.warning"];
            [self hideLoading];
            return;
        }
        paymentDetails = [[MidtransPaymentTelkomselCash alloc] initWithMSISDN:self.view.emailTextField.text];
    }
    else if ([self.paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_KIOS_ON]) {
        paymentDetails = [[MidtransPaymentKiosOn alloc] init];
    }
    
    MidtransTransaction *transaction = [[MidtransTransaction alloc] initWithPaymentDetails:paymentDetails token:self.token];

    [[MidtransMerchantClient shared] performTransaction:transaction completion:^(MidtransTransactionResult *result, NSError *error) {
        [self hideLoading];
        if (error) {
            [self handleTransactionError:error];
        } else {
            if ( [self.paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_KIOS_ON] ||  [self.paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_INDOMARET]) {
                 SNPPostPaymentGeneralViewController *postPaymentVAController = [[SNPPostPaymentGeneralViewController alloc] initWithNibName:@"SNPPostPaymentGeneralViewController" bundle:VTBundle];
                postPaymentVAController.token = self.token;
                postPaymentVAController.paymentMethod = self.paymentMethod;
                postPaymentVAController.transactionDetail = transaction;
                postPaymentVAController.transactionResult = result;
                [self.navigationController pushViewController:postPaymentVAController animated:YES];
            }else {
                [self handleTransactionSuccess:result];
            }
        }
    }];
}

@end
