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
#import "MidtransUIThemeManager.h"
#import "MIDUITrackingManager.h"
#import "MIDConstants.h"
#import "MidtransDeviceHelper.h"

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
    
    if (self.paymentMethod.method == MIDPaymentMethodKlikbca) {
        self.view.disclosureButtonImage.hidden = YES;
    }
    
    [[MIDUITrackingManager shared] trackEventName:[NSString stringWithFormat:@"pg %@",self.paymentMethod.shortName]];
    
    [self addNavigationToTextFields:@[self.view.emailTextField]];
    self.view.totalAmountLabel.text = self.info.transaction.grossAmount.formattedCurrencyNumber;
    self.view.orderIdLabel.text = self.info.transaction.orderID;
    self.view.instructionTitleLabel.text = [NSString stringWithFormat:[VTClassHelper getTranslationFromAppBundleForString:@"%@ step by step"], self.paymentMethod.title];
    if ([[MidtransDeviceHelper deviceCurrentLanguage] isEqualToString:@"id"]) {
        self.view.instructionTitleLabel.text = [NSString stringWithFormat:@" Panduan pembayaran melalui %@", self.paymentMethod.title];
    }
    [self.view initViewWithPaymentMethod:self.paymentMethod email:self.info.customer.email];
    
    [self.view.totalAmountBorderedView addGestureRecognizer:
     [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(totalAmountBorderedViewTapped:)]];
    self.view.totalAmountLabel.textColor = [[MidtransUIThemeManager shared] themeColor];
}
- (void) totalAmountBorderedViewTapped:(id) sender {
    MidtransTransactionDetailViewController *transactionViewController = [[MidtransTransactionDetailViewController alloc] initWithNibName:@"MidtransTransactionDetailViewController" bundle:VTBundle];
    [transactionViewController presentAtPositionOfView:self.view.totalAmountBorderedView items:self.info.items];
}

- (IBAction)confirmPaymentDidTapped:(id)sender {
    [self showLoadingWithText:nil];
    [[MIDUITrackingManager shared] trackEventName:@"btn confirm payment"];
    
    if (self.paymentMethod.method == MIDPaymentMethodKlikbca) {
        NSString *_email = self.view.emailTextField.text;
        
        if (_email.length == 0) {
            self.view.emailTextField.warning = [VTClassHelper getTranslationFromAppBundleForString:@"payment.klikbca.userid-warning"];
            [self hideLoading];
            return;
        }
        
        [MIDDirectDebitCharge klikbcaWithToken:self.snapToken userID:_email completion:^(MIDKlikbcaResult * _Nullable result, NSError * _Nullable error) {
            [self hideLoading];
            
            if (error) {
                [self handleTransactionError:error];
            } else {
                [self handleTransactionSuccess:result];
            }
        }];
    }
    else if (self.paymentMethod.method == MIDPaymentMethodTelkomselCash) {
        NSString *customer = self.view.emailTextField.text;
        if (customer.length == 0) {
            self.view.emailTextField.warning = [VTClassHelper getTranslationFromAppBundleForString:@"payment.telkomsel-cash.warning"];
            [self hideLoading];
            return;
        }
        
        [MIDEWalletCharge telkomselCashWithToken:self.snapToken customer:customer completion:^(MIDTelkomselCashResult * _Nullable result, NSError * _Nullable error) {
            [self hideLoading];
            
            if (error) {
                [self handleTransactionError:error];
            } else {
                [self handleTransactionSuccess:result];
            }
        }];
    }    
}

@end
