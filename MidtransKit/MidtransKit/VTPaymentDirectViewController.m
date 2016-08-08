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

#import <MidtransCoreKit/MidtransCoreKit.h>

@interface VTPaymentDirectViewController ()
@property (strong, nonatomic) IBOutlet VTPaymentDirectView *view;
@property (nonatomic) VTVAType paymentType;
@end

@implementation VTPaymentDirectViewController
@dynamic view;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addNavigationToTextFields:@[self.view.directPaymentTextField]];
    
    NSString *paymentName;
    
    if ([self.paymentMethod.internalBaseClassIdentifier isEqualToString:VT_PAYMENT_INDOSAT_DOMPETKU]) {
        self.view.directPaymentTextField.keyboardType = UIKeyboardTypePhonePad;
        
        self.view.directPaymentTextField.placeholder = UILocalizedString(@"payment.indosat-dompetku.token-placeholder", nil);
        self.view.vtInformationLabel.text = UILocalizedString(@"payment.indosat-dompetku.token-note", nil);
        paymentName = UILocalizedString(@"payment.indosat-dompetku.header-title", nil);
    }
    else {
        self.view.directPaymentTextField.keyboardType = UIKeyboardTypeDefault;
        
        if ([self.paymentMethod.internalBaseClassIdentifier isEqualToString:VT_PAYMENT_KLIK_BCA_IDENTIFIER2]) {
            self.view.directPaymentTextField.placeholder = UILocalizedString(@"KlikBCA User ID", nil);
            self.view.vtInformationLabel.text = UILocalizedString(@"payment.klikbca.userid-note", nil);
            paymentName  =  UILocalizedString(@"KlikBCA",nil);
        }
        else if ([self.paymentMethod.internalBaseClassIdentifier isEqualToString:VT_PAYMENT_TELKOMSEL_CASH]) {
            self.view.directPaymentTextField.placeholder = UILocalizedString(@"payment.telkomsel-cash.token-placeholder", nil);
            self.view.vtInformationLabel.text = UILocalizedString(@"payment.telkomsel-cash.token-note", nil);
            paymentName = UILocalizedString(@"payment.telkomsel-cash.header-title", nil);
        }
        else {
            self.view.directPaymentTextField.text = self.token.customerDetails.email;
            self.view.directPaymentTextField.placeholder = UILocalizedString(@"payment.email-placeholder", nil);
            self.view.vtInformationLabel.text = UILocalizedString(@"payment.email-note", nil);
            
            if ([self.paymentMethod.internalBaseClassIdentifier isEqualToString:VT_PAYMENT_INDOMARET]) {
                paymentName  = UILocalizedString(@"Indomaret",nil);
            }
            else if ([self.paymentMethod.internalBaseClassIdentifier isEqualToString:VT_VA_BCA_IDENTIFIER]) {
                self.paymentType = VTVATypeBCA;
                paymentName  =  UILocalizedString(@"BCA ATM",nil);
            }
            else if ([self.paymentMethod.internalBaseClassIdentifier isEqualToString:VT_VA_MANDIRI_IDENTIFIER]) {
                self.paymentType = VTVATypeMandiri;
                paymentName  =  UILocalizedString(@"Mandiri ATM",nil);
            }
            else if ([self.paymentMethod.internalBaseClassIdentifier isEqualToString:VT_VA_PERMATA_IDENTIFIER]) {
                self.paymentType = VTVATypePermata;
                paymentName  =  UILocalizedString(@"Permata ATM",nil);
            }
            else if ([self.paymentMethod.internalBaseClassIdentifier isEqualToString:VT_VA_OTHER_IDENTIFIER]) {
                self.paymentType = VTVATypeOther;
                paymentName  =  UILocalizedString(@"name.other-bank",nil);
            }
        }
    }
    
    
    
    self.title = paymentName;
    [self.view.howToPaymentButton setTitle:[NSString stringWithFormat:UILocalizedString(@"payment.how",nil) ,paymentName]
                                  forState:UIControlStateNormal];
    self.view.totalAmountLabel.text = self.token.transactionDetails.grossAmount.formattedCurrencyNumber;
    self.view.orderIdLabel.text = self.token.transactionDetails.orderId;
}
- (IBAction)paymentGuideDidTapped:(id)sender {
    
}
- (IBAction)confirmPaymentDidTapped:(id)sender {
    [self showLoadingHud];
    
    id<VTPaymentDetails> paymentDetails;
    
    if ([self.paymentMethod.internalBaseClassIdentifier isEqualToString:VT_VA_BCA_IDENTIFIER] ||
        [self.paymentMethod.internalBaseClassIdentifier isEqualToString:VT_VA_MANDIRI_IDENTIFIER] ||
        [self.paymentMethod.internalBaseClassIdentifier isEqualToString:VT_VA_PERMATA_IDENTIFIER] ||
        [self.paymentMethod.internalBaseClassIdentifier isEqualToString:VT_VA_OTHER_IDENTIFIER]) {
        
        paymentDetails = [[VTPaymentBankTransfer alloc] initWithBankTransferType:self.paymentType
                                                                           token:self.token
                                                                           email:self.view.directPaymentTextField.text];
        self.token.customerDetails.email = self.view.directPaymentTextField.text;
    }
    else if ([self.paymentMethod.internalBaseClassIdentifier isEqualToString:VT_PAYMENT_KLIK_BCA_IDENTIFIER2]){
        if (self.view.directPaymentTextField.text.length == 0) {
            self.view.directPaymentTextField.warning = UILocalizedString(@"payment.klikbca.userid-warning", nil);
            [self hideLoadingHud];
            return;
        }
        paymentDetails = [[VTPaymentKlikBCA alloc] initWithKlikBCAUserId:self.view.directPaymentTextField.text token:self.token];
    }
    else if ([self.paymentMethod.internalBaseClassIdentifier isEqualToString:VT_PAYMENT_INDOMARET]) {
        paymentDetails = [[VTPaymentCStore alloc] initWithToken:self.token];
        self.token.customerDetails.email = self.view.directPaymentTextField.text;
    }
    else if ([self.paymentMethod.internalBaseClassIdentifier isEqualToString:VT_PAYMENT_INDOSAT_DOMPETKU]) {
        if (self.view.directPaymentTextField.text.length == 0) {
            self.view.directPaymentTextField.warning = UILocalizedString(@"payment.indosat-dompetku.warning", nil);
            [self hideLoadingHud];
            return;
        }
        paymentDetails = [[VTPaymentIndosatDompetku alloc] initWithMSISDN:self.view.directPaymentTextField.text
                                                                    token:self.token];
    }
    else if ([self.paymentMethod.internalBaseClassIdentifier isEqualToString:VT_PAYMENT_TELKOMSEL_CASH]) {
        if (self.view.directPaymentTextField.text.length == 0) {
            self.view.directPaymentTextField.warning = UILocalizedString(@"payment.telkomsel-cash.warning", nil);
            [self hideLoadingHud];
            return;
        }
        paymentDetails = [[VTPaymentTelkomselCash alloc] initWithMSISDN:self.view.directPaymentTextField.text
                                                                  token:self.token];
    }
    
    VTTransaction *transaction = [[VTTransaction alloc] initWithPaymentDetails:paymentDetails];
    [[VTMerchantClient sharedClient] performTransaction:transaction completion:^(VTTransactionResult *result, NSError *error) {
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

- (void)handleTransactionSuccess:(VTTransactionResult *)result {
    if ([self.paymentMethod.internalBaseClassIdentifier isEqualToString:VT_VA_BCA_IDENTIFIER] ||
        [self.paymentMethod.internalBaseClassIdentifier isEqualToString:VT_VA_MANDIRI_IDENTIFIER] ||
        [self.paymentMethod.internalBaseClassIdentifier isEqualToString:VT_VA_PERMATA_IDENTIFIER] ||
        [self.paymentMethod.internalBaseClassIdentifier isEqualToString:VT_VA_OTHER_IDENTIFIER])
    {
        VTVATransactionStatusViewModel *vm = [[VTVATransactionStatusViewModel alloc] initWithTransactionResult:result
                                                                                                        vaType:self.paymentType];
        if (self.paymentType == VTVATypeMandiri) {
            VTBillpaySuccessController *vc = [[VTBillpaySuccessController alloc] initWithToken:self.token
                                                                             paymentMethodName:self.paymentMethod
                                                                                   statusModel:vm];
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            VTVASuccessStatusController *vc = [[VTVASuccessStatusController alloc] initWithToken:self.token
                                                                               paymentMethodName:self.paymentMethod
                                                                                     statusModel:vm];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else if ([self.paymentMethod.internalBaseClassIdentifier isEqualToString:VT_PAYMENT_INDOMARET]) {
        VTPaymentStatusViewModel *vm = [[VTPaymentStatusViewModel alloc] initWithTransactionResult:result];
        VTIndomaretSuccessController *vc = [[VTIndomaretSuccessController alloc] initWithToken:self.token
                                                                             paymentMethodName:self.paymentMethod
                                                                                   statusModel:vm];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else {
        [super handleTransactionSuccess:result];
    }
}

@end
