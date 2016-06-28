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
#import "VTKeyboardAccessoryView.h"

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

@end

@implementation VTMandiriClickpayController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Mandiri Clickpay";
    
    [self addNavigationToTextFields:@[_debitNumberTextField, _tokenTextField]];
    
    _debitNumberTextField.delegate = self;
    _tokenTextField.delegate = self;
    
    _appliLabel.text = ClickpayAPPLI;
    _input1Label.text = [VTMandiriClickpayHelper generateInput1FromCardNumber:_debitNumberTextField.text];
    _input2Label.text = [VTMandiriClickpayHelper generateInput2FromGrossAmount:self.transactionDetails.grossAmount];
    _input3Label.text = [VTMandiriClickpayHelper generateInput3];
    
    _amountLabel.text = self.transactionDetails.grossAmount.formattedCurrencyNumber;
}

- (IBAction)confirmPaymentPressed:(UIButton *)sender {
    _tokenTextField.warning = nil;
    _debitNumberTextField.warning = nil;
    
    if ([_debitNumberTextField.text isValidClickpayNumber] == NO) {
        _debitNumberTextField.warning = UILocalizedString(@"clickpay.invalid-number", nil);
        return;
    }
    
    if ([_tokenTextField.text isValidClickpayToken] == NO) {
        _tokenTextField.warning = UILocalizedString(@"clickpay.invalid-token", nil);
        return;
    }
    
    [self showLoadingHud];
    
    VTPaymentMandiriClickpay *paymentDetails = [[VTPaymentMandiriClickpay alloc] initWithCardNumber:_debitNumberTextField.text grossAmount:self.transactionDetails.grossAmount token:_tokenTextField.text];
    
    VTTransaction *transaction = [[VTTransaction alloc] initWithPaymentDetails:paymentDetails
                                                            transactionDetails:self.transactionDetails
                                                               customerDetails:self.customerDetails
                                                                   itemDetails:self.itemDetails];
    
    [[VTMerchantClient sharedClient] performTransaction:transaction completion:^(VTTransactionResult *result, NSError *error) {
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
    if ([textField isEqual:_debitNumberTextField]) {
        NSMutableString *mstring = [NSMutableString stringWithString:textField.text];
        [mstring replaceCharactersInRange:range withString:string];
        _input1Label.text = [VTMandiriClickpayHelper generateInput1FromCardNumber:_debitNumberTextField.text];
        
        return [textField filterCreditCardWithString:string range:range];
    } else if ([textField isEqual:_tokenTextField]) {
        NSInteger clickpayTokenLenth = 6;
        return [textField filterNumericWithString:string range:range length:clickpayTokenLenth];
    }
    return YES;
}

@end
