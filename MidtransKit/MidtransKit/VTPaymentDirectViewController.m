//
//  VTPaymentDirectViewController.m
//  MidtransKit
//
//  Created by Arie on 6/18/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTPaymentDirectViewController.h"
#import "VTPaymentDirectView.h"
#import "VTTextField.h"
#import "VTButton.h"
#import "VTVATransactionStatusViewModel.h"
#import "VTBillpaySuccessController.h"
#import "VTVASuccessStatusController.h"
#import "VTIndomaretSuccessController.h"
#import "VTKlikbcaSuccessController.h"
#import "VTPendingStatusController.h"

#import <MidtransCoreKit/MidtransCoreKit.h>

@interface VTPaymentDirectViewController ()
@property (strong, nonatomic) IBOutlet VTPaymentDirectView *view;
@property (nonatomic) MidtransVAType paymentType;
@end

@implementation VTPaymentDirectViewController
@dynamic view;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addNavigationToTextFields:@[self.view.directPaymentTextField]];
    
    if ([self.paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_INDOSAT_DOMPETKU]) {
        self.view.directPaymentTextField.keyboardType = UIKeyboardTypePhonePad;
        self.view.directPaymentTextField.placeholder = UILocalizedString(@"payment.indosat-dompetku.token-placeholder", nil);
        self.view.vtInformationLabel.text = UILocalizedString(@"payment.indosat-dompetku.token-note", nil);
    }
    else {
        self.view.directPaymentTextField.keyboardType = UIKeyboardTypeEmailAddress;
        
        if ([self.paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_KLIK_BCA]) {
            self.view.directPaymentTextField.placeholder = UILocalizedString(@"KlikBCA User ID", nil);
            self.view.vtInformationLabel.text = UILocalizedString(@"payment.klikbca.userid-note", nil);
        }
        else if ([self.paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_TELKOMSEL_CASH]) {
            self.view.directPaymentTextField.placeholder = UILocalizedString(@"payment.telkomsel-cash.token-placeholder", nil);
            self.view.vtInformationLabel.text = UILocalizedString(@"payment.telkomsel-cash.token-note", nil);
        }
        else {
            self.view.directPaymentTextField.text = self.token.customerDetails.email;
            self.view.directPaymentTextField.placeholder = UILocalizedString(@"payment.email-placeholder", nil);
            self.view.vtInformationLabel.text = UILocalizedString(@"payment.email-note", nil);
            
            if ([self.paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_KIOS_ON]) {
                self.view.noteLabel.text = UILocalizedString(@"payment.kioson.note", nil);
            }
            else {
                if ([self.paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_VA_BCA_IDENTIFIER]) {
                    self.paymentType = VTVATypeBCA;
                }
                else if ([self.paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_VA_MANDIRI_IDENTIFIER]) {
                    self.paymentType = VTVATypeMandiri;
                }
                else if ([self.paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_VA_PERMATA_IDENTIFIER]) {
                    self.paymentType = VTVATypePermata;
                }
                else if ([self.paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_VA_OTHER_IDENTIFIER]) {
                    self.paymentType = VTVATypeOther;
                }
            }
        }
    }
    
    self.title = self.paymentMethod.title;
    
    [self.view.howToPaymentButton setTitle:[NSString stringWithFormat:UILocalizedString(@"payment.how",nil), self.title]
                                  forState:UIControlStateNormal];
    self.view.totalAmountLabel.text = self.token.transactionDetails.grossAmount.formattedCurrencyNumber;
    self.view.orderIdLabel.text = self.token.transactionDetails.orderId;
}
- (IBAction)paymentGuideDidTapped:(id)sender {
    
}
- (IBAction)confirmPaymentDidTapped:(id)sender {
    [self showLoadingHud];
    
    id<MidtransPaymentDetails> paymentDetails;
    
    if ([self.paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_VA_BCA_IDENTIFIER] ||
        [self.paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_VA_MANDIRI_IDENTIFIER] ||
        [self.paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_VA_PERMATA_IDENTIFIER] ||
        [self.paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_VA_OTHER_IDENTIFIER]) {
        
        paymentDetails = [[MidtransPaymentBankTransfer alloc] initWithBankTransferType:self.paymentType
                                                                                 token:self.token
                                                                                 email:self.view.directPaymentTextField.text];
        self.token.customerDetails.email = self.view.directPaymentTextField.text;
    }
    else if ([self.paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_KLIK_BCA]){
        if (self.view.directPaymentTextField.text.length == 0) {
            self.view.directPaymentTextField.warning = UILocalizedString(@"payment.klikbca.userid-warning", nil);
            [self hideLoadingHud];
            return;
        }
        paymentDetails = [[MidtransPaymentKlikBCA alloc] initWithKlikBCAUserId:self.view.directPaymentTextField.text token:self.token];
    }
    else if ([self.paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_INDOMARET]) {
        paymentDetails = [[MidtransPaymentCStore alloc] initWithToken:self.token];
        self.token.customerDetails.email = self.view.directPaymentTextField.text;
    }
    else if ([self.paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_INDOSAT_DOMPETKU]) {
        if (self.view.directPaymentTextField.text.length == 0) {
            self.view.directPaymentTextField.warning = UILocalizedString(@"payment.indosat-dompetku.warning", nil);
            [self hideLoadingHud];
            return;
        }
        paymentDetails = [[MidtransPaymentIndosatDompetku alloc] initWithMSISDN:self.view.directPaymentTextField.text
                                                                          token:self.token];
    }
    else if ([self.paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_TELKOMSEL_CASH]) {
        if (self.view.directPaymentTextField.text.length == 0) {
            self.view.directPaymentTextField.warning = UILocalizedString(@"payment.telkomsel-cash.warning", nil);
            [self hideLoadingHud];
            return;
        }
        paymentDetails = [[MidtransPaymentTelkomselCash alloc] initWithMSISDN:self.view.directPaymentTextField.text
                                                                        token:self.token];
    }
    else if ([self.paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_KIOS_ON]) {
        paymentDetails = [[MidtransPaymentKiosOn alloc] initWithToken:self.token];
    }
    
    MidtransTransaction *transaction = [[MidtransTransaction alloc] initWithPaymentDetails:paymentDetails];
    [[MidtransMerchantClient sharedClient] performTransaction:transaction completion:^(MidtransTransactionResult *result, NSError *error) {
        [self hideLoadingHud];
        if (error) {
            [self handleTransactionError:error];
        } else {
            [self handleTransactionSuccess:result];
        }
    }];
}

- (IBAction)howtoButtonDidTapped:(id)sender {
    [self showGuideViewController];
}

- (void)handleTransactionSuccess:(MidtransTransactionResult *)result {
    if ([self.paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_VA_BCA_IDENTIFIER] ||
        [self.paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_VA_MANDIRI_IDENTIFIER] ||
        [self.paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_VA_PERMATA_IDENTIFIER] ||
        [self.paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_VA_OTHER_IDENTIFIER])
    {
        VTVATransactionStatusViewModel *vm = [[VTVATransactionStatusViewModel alloc] initWithTransactionResult:result
                                                                                                        vaType:self.paymentType];
        if (self.paymentType == VTVATypeMandiri) {
            VTBillpaySuccessController *vc = [[VTBillpaySuccessController alloc] initWithToken:self.token
                                                                             paymentMethodName:self.paymentMethod
                                                                                   statusModel:vm];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else {
            VTVASuccessStatusController *vc = [[VTVASuccessStatusController alloc] initWithToken:self.token
                                                                               paymentMethodName:self.paymentMethod
                                                                                     statusModel:vm];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else if ([self.paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_INDOMARET]) {
        VTPaymentStatusViewModel *vm = [[VTPaymentStatusViewModel alloc] initWithTransactionResult:result];
        VTIndomaretSuccessController *vc = [[VTIndomaretSuccessController alloc] initWithToken:self.token
                                                                             paymentMethodName:self.paymentMethod
                                                                                   statusModel:vm];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([self.paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_KLIK_BCA]) {
        VTPaymentStatusViewModel *vm = [[VTPaymentStatusViewModel alloc] initWithTransactionResult:result];
        VTKlikbcaSuccessController *vc = [[VTKlikbcaSuccessController alloc] initWithToken:self.token paymentMethodName:self.paymentMethod viewModel:vm];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([self.paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_KIOS_ON]) {
        VTPendingStatusController *vc = [[VTPendingStatusController alloc] initWithToken:self.token paymentMethodName:self.paymentMethod result:result];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else {
        [super handleTransactionSuccess:result];
    }
}

@end
