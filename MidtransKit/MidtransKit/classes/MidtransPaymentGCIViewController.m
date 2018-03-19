//
//  MidtransPaymentGCIViewController.m
//  MidtransKit
//
//  Created by Vanbungkring on 12/16/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MidtransPaymentGCIViewController.h"
#import "MidtransPaymentGCIView.h"
#import "VTClassHelper.h"
#import "MidtransUITextField.h"
#import "IHKeyboardAvoiding_vt.h"
#import "MidtransUICardFormatter.h"
#import <MidtransCoreKit/MidtransCoreKit.h>
#import "MidtransTransactionDetailViewController.h"
#import "MIdtransUIBorderedView.h"
#import "MidtransUIThemeManager.h"

@interface MidtransPaymentGCIViewController () <UITextFieldDelegate,MidtransUICardFormatterDelegate>
@property (strong, nonatomic) IBOutlet MidtransPaymentGCIView *view;
@property (nonatomic) MidtransUICardFormatter *ccFormatter;
@property (nonatomic) NSInteger attemptRetry;
@end

@implementation MidtransPaymentGCIViewController
@dynamic view;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.attemptRetry = 0;
    [self addNavigationToTextFields:@[self.view.gciCardTextField,self.view.passwordTextField]];
    self.title = self.paymentMethod.title;
    self.view.amountTotalLabel.text = self.token.transactionDetails.grossAmount.formattedCurrencyNumber;
    self.view.orderIdLabel.text = self.token.transactionDetails.orderId;
    self.ccFormatter = [[MidtransUICardFormatter alloc] initWithTextField:self.view.gciCardTextField];
    self.ccFormatter.numberLimit = 16;
    self.ccFormatter.delegate = self;
    
    self.view.gciCardTextField.placeholder = [VTClassHelper getTranslationFromAppBundleForString:@"gci.placeholder"];
    self.view.totalAmountLabel.text = [VTClassHelper getTranslationFromAppBundleForString:@"total.amount"];
    [self.view.confirmButton setTitle:[VTClassHelper getTranslationFromAppBundleForString:@"confirm.payment"] forState:UIControlStateNormal];
    [self.view.totalAmountBorderedView addGestureRecognizer:
     [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(totalAmountBorderedViewTapped:)]];
    self.view.totalAmountLabel.textColor = [[MidtransUIThemeManager shared] themeColor];
}
- (void) totalAmountBorderedViewTapped:(id) sender {
    MidtransTransactionDetailViewController *transactionViewController = [[MidtransTransactionDetailViewController alloc] initWithNibName:@"MidtransTransactionDetailViewController" bundle:VTBundle];
    [transactionViewController presentAtPositionOfView:self.view.totalAmountBorderedView items:self.token.itemDetails];
}
-(void)textFieldDidChange :(UITextField *) textField{
    if ([textField isEqual:self.view.gciCardTextField]) {
        [self.ccFormatter updateTextFieldContentAndPosition];
    }
    //your code
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSError *error;
    
    if ([textField isEqual:self.view.gciCardTextField]) {
        [textField.text isValidCreditCardNumber:&error];
    }
    else {
        if (self.view.passwordTextField.text.SNPisEmpty) {
             [textField.text isValidValue:&error];
        }
    }

}

- (IBAction)confirmPaymentButtonDidTapped:(id)sender {
   if (self.view.gciCardTextField.text.SNPisEmpty) {
        self.view.gciCardTextField.warning = [VTClassHelper getTranslationFromAppBundleForString:@"Card Number cannot be empty"];
        return;
    }
     else if (self.view.passwordTextField.text.SNPisEmpty) {
       self.view.passwordTextField.warning = [VTClassHelper getTranslationFromAppBundleForString:@"PIN cannot be empty"];
        return;
    }
    [self showLoadingWithText:[VTClassHelper getTranslationFromAppBundleForString:@"Loading"]];
    MIdtransPaymentGCI *paymentDetails = [[MIdtransPaymentGCI alloc] initWithCardNumber:self.view.gciCardTextField.text
                                                                               password:self.view.passwordTextField.text];

    MidtransTransaction *transaction = [[MidtransTransaction alloc] initWithPaymentDetails:paymentDetails
                                                                                     token:self.token];
    
    [[MidtransMerchantClient shared] performTransaction:transaction
                                             completion:^(MidtransTransactionResult *result, NSError *error) {
        [self hideLoading];
        if (error) {
            if (self.attemptRetry<2) {
                self.attemptRetry+=1;
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR"
                                                                message:error.localizedDescription
                                                               delegate:nil
                                                      cancelButtonTitle:[VTClassHelper getTranslationFromAppBundleForString:@"Close"]
                                                      otherButtonTitles:nil];
                [alert show];
            }
            else {
               [self handleTransactionError:error];
            }
            
        }
        else {
            if ([result.transactionStatus isEqualToString:MIDTRANS_TRANSACTION_STATUS_DENY] && self.attemptRetry<2) {
                  self.attemptRetry+=1;
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[result.transactionStatus capitalizedString]
                                                                message:result.statusMessage
                                                               delegate:nil
                                                      cancelButtonTitle:[VTClassHelper getTranslationFromAppBundleForString:@"Close"]
                                                      otherButtonTitles:nil];
                [alert show];
            }
            else {
             [self handleTransactionSuccess:result];
            }
        }

    }];

    
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([textField isKindOfClass:[MidtransUITextField class]]) {
        ((MidtransUITextField *) textField).warning = nil;
    }
    
    if ([textField isEqual:self.view.gciCardTextField]) {
        return [self.ccFormatter updateTextFieldContentAndPosition];
    }
    else if ([textField isEqual:self.view.passwordTextField]) {
        if (range.length + range.location > textField.text.length)
        {
            return NO;
        }
        
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return newLength <= 6;
    }
    else {
        return YES;
    }
}
- (void)reformatCardNumber {
    NSString *cardNumber = self.view.gciCardTextField.text;
    NSString *formatted = [NSString stringWithFormat: @"%@ %@ %@ %@",
                           [cardNumber substringWithRange:NSMakeRange(0,4)],
                           [cardNumber substringWithRange:NSMakeRange(4,4)],
                           [cardNumber substringWithRange:NSMakeRange(8,4)],
                           [cardNumber substringWithRange:NSMakeRange(12,4)]];
    
    self.view.gciCardTextField.text = formatted;
    
}

#pragma mark - VTCardFormatterDelegate

- (void)formatter_didTextFieldChange:(MidtransUICardFormatter *)formatter {
}
@end
