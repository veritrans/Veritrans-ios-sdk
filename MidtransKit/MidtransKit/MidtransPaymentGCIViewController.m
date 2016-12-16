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
#import "MidtransUICardFormatter.h"
#import <MidtransCoreKit/MidtransCorekit.h>
@interface MidtransPaymentGCIViewController () <UITextFieldDelegate,MidtransUICardFormatterDelegate>
@property (strong, nonatomic) IBOutlet MidtransPaymentGCIView *view;
@property (nonatomic) MidtransUICardFormatter *ccFormatter;
@end

@implementation MidtransPaymentGCIViewController
@dynamic view;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.paymentMethod.title;
    self.view.amountTotalLabel.text = self.token.transactionDetails.grossAmount.formattedCurrencyNumber;
    self.view.orderIdLabel.text = self.token.transactionDetails.orderId;
    
    self.ccFormatter = [[MidtransUICardFormatter alloc] initWithTextField:(UITextField *)self.view.gciCardTextField];
    self.ccFormatter.delegate = self;
    
    
    // Do any additional setup after loading the view from its nib.
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
        if (self.view.passwordTextField.text.isEmpty) {
             [textField.text isValidValue:&error];
        }
    }

}

- (IBAction)confirmPaymentButtonDidTapped:(id)sender {
   if (self.view.gciCardTextField.text.isEmpty) {
        self.view.gciCardTextField.warning = @"Card Number cannot be empty";
        return;
    }
     else if (self.view.passwordTextField.text.isEmpty) {
       self.view.passwordTextField.warning = @"Password cannot be empty";
        return;
    }
    [self showLoadingWithText:@"Loading"];
    MIdtransPaymentGCI *paymentDetails = [[MIdtransPaymentGCI alloc] initWithCardNumber:self.view.gciCardTextField.text password:self.view.passwordTextField.text];
    NSLog(@"data-->%@",[paymentDetails dictionaryValue]);
    MidtransTransaction *transaction = [[MidtransTransaction alloc] initWithPaymentDetails:paymentDetails token:self.token];
    
    [[MidtransMerchantClient shared] performTransaction:transaction completion:^(MidtransTransactionResult *result, NSError *error) {
        [self hideLoading];
        
        if (error) {
            [self handleTransactionError:error];
        }
        else {
            [self handleTransactionSuccess:result];
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

    else {
        return YES;
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
