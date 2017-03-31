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
#import "VTClassHelper.h"

#import <MidtransCoreKit/MidtransCoreKit.h>

@interface MidtransUIPaymentDirectViewController ()
@property (strong, nonatomic) IBOutlet MidtransUIPaymentDirectView *view;
@property (nonatomic) MidtransVAType paymentType;
@end

@implementation MidtransUIPaymentDirectViewController
@dynamic view;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.paymentMethod.title;
    
    [[SNPUITrackingManager shared] trackEventName:[NSString stringWithFormat:@"pg %@",self.paymentMethod.shortName]];
     [self addNavigationToTextFields:@[self.view.emailTextField]];
    self.view.totalAmountLabel.text = self.token.transactionDetails.grossAmount.formattedCurrencyNumber;
    self.view.instructionTitleLabel.text = [NSString stringWithFormat:@"%@ step by step", self.paymentMethod.title];
    [self.view initViewWithPaymentID:self.paymentMethod.internalBaseClassIdentifier email:self.token.customerDetails.email];
}
- (void)setPaymentType:(MidtransVAType)paymentType {
    _paymentType = paymentType;
    [self.view.confirmPaymentButton setTitle:UILocalizedString(@"payment.va.confirm_button", nil) forState:UIControlStateNormal];
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
    else if ([self.paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_KLIK_BCA]){
        if (self.view.emailTextField.text.length == 0) {
            self.view.emailTextField.warning = UILocalizedString(@"payment.klikbca.userid-warning", nil);
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
            self.view.emailTextField.warning = UILocalizedString(@"payment.indosat-dompetku.warning", nil);
            [self hideLoading];
            return;
        }
        paymentDetails = [[MidtransPaymentIndosatDompetku alloc] initWithMSISDN:self.view.emailTextField.text];
    }
    else if ([self.paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_TELKOMSEL_CASH]) {
        if (self.view.emailTextField.text.length == 0) {
            self.view.emailTextField.warning = UILocalizedString(@"payment.telkomsel-cash.warning", nil);
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
            [self handleTransactionSuccess:result];
        }
    }];
}

@end
