//
//  VTClickpayController.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 2/29/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTMandiriClickpayController.h"
#import "VTClassHelper.h"
#import "VTTextField.h"
#import "VTHudView.h"
#import "VTCardFormatter.h"

#import <MidtransCoreKit/MidtransCoreKit.h>

static NSString* const ClickpayAPPLI = @"3";

@interface VTMandiriClickpayController () <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet VTTextField *debitNumberTextField;
@property (strong, nonatomic) IBOutlet VTTextField *tokenTextField;
@property (strong, nonatomic) IBOutlet UILabel *amountLabel;
@property (strong, nonatomic) IBOutlet UILabel *appliLabel;
@property (strong, nonatomic) IBOutlet UILabel *input1Label;
@property (strong, nonatomic) IBOutlet UILabel *input2Label;
@property (strong, nonatomic) IBOutlet UILabel *input3Label;

@property (nonatomic) VTCardFormatter *ccFormatter;

@end

@implementation VTMandiriClickpayController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = self.paymentMethod.title;
    
    [self addNavigationToTextFields:@[self.debitNumberTextField, self.tokenTextField]];
    
    self.debitNumberTextField.delegate = self;
    self.tokenTextField.delegate = self;
    
    self.appliLabel.text = ClickpayAPPLI;
    self.input1Label.text = [VTMandiriClickpayHelper generateInput1FromCardNumber:self.debitNumberTextField.text];
    self.input2Label.text = [VTMandiriClickpayHelper generateInput2FromGrossAmount:self.token.transactionDetails.grossAmount];
    self.input3Label.text = [VTMandiriClickpayHelper generateInput3];
    
    self.amountLabel.text = self.token.transactionDetails.grossAmount.formattedCurrencyNumber;
    
    self.ccFormatter = [[VTCardFormatter alloc] initWithTextField:self.debitNumberTextField];
    self.ccFormatter.numberLimit = 16;
}

- (IBAction)confirmPaymentPressed:(UIButton *)sender {
    self.tokenTextField.warning = nil;
    self.debitNumberTextField.warning = nil;
    
    if ([self.debitNumberTextField.text isValidClickpayNumber] == NO) {
        self.debitNumberTextField.warning = UILocalizedString(@"clickpay.invalid-number", nil);
        return;
    }
    
    if ([self.tokenTextField.text isValidClickpayToken] == NO) {
        self.tokenTextField.warning = UILocalizedString(@"clickpay.invalid-token", nil);
        return;
    }
    
    [self showLoadingHud];
   
    MidtransPaymentMandiriClickpay *paymentDetails = [[VTPaymentMandiriClickpay alloc] initWithCardNumber:self.debitNumberTextField.text clickpayToken:self.tokenTextField.text token:self.token];
    
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

- (IBAction)clickpayHelpPressed:(UIButton *)sender {
    [self showGuideViewController];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([textField isEqual:self.debitNumberTextField]) {
        return [self.ccFormatter updateTextFieldContentAndPosition];
    } else if ([textField isEqual:self.tokenTextField]) {
        NSInteger clickpayTokenLenth = 6;
        return [textField filterNumericWithString:string range:range length:clickpayTokenLenth];
    }
    return YES;
}

@end
