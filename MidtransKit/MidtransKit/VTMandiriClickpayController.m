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
#import "VTClickpayGuideController.h"
#import "VTHudView.h"

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

@property (nonatomic) VTHudView *hudView;

@end

@implementation VTMandiriClickpayController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Mandiri Clickpay";
    
    _hudView = [[VTHudView alloc] init];
    
    _debitNumberTextField.delegate = self;
    _tokenTextField.delegate = self;
    
    _appliLabel.text = ClickpayAPPLI;
    _input1Label.text = [VTMandiriClickpayHelper generateInput1FromCardNumber:_debitNumberTextField.text];
    _input2Label.text = [VTMandiriClickpayHelper generateInput2FromGrossAmount:self.transactionDetails.grossAmount];
    _input3Label.text = [VTMandiriClickpayHelper generateInput3];
    
    NSNumberFormatter *formatter = [NSNumberFormatter indonesianCurrencyFormatter];
    _amountLabel.text = [formatter stringFromNumber:self.transactionDetails.grossAmount];
}

- (IBAction)confirmPaymentPressed:(UIButton *)sender {
    [_hudView showOnView:self.navigationController.view];
    
    VTPaymentMandiriClickpay *paymentDetails = [[VTPaymentMandiriClickpay alloc] initWithCardNumber:_debitNumberTextField.text grossAmount:self.transactionDetails.grossAmount token:_tokenTextField.text];
    
    VTTransaction *transaction = [[VTTransaction alloc] initWithPaymentDetails:paymentDetails
                                                            transactionDetails:self.transactionDetails
                                                               customerDetails:self.customerDetails
                                                                   itemDetails:self.itemDetails];
    
    [[VTMerchantClient sharedClient] performTransaction:transaction completion:^(VTTransactionResult *result, NSError *error) {
        [_hudView hide];
        
        if (error) {
            [self handleTransactionError:error];
        } else {
            [self handleTransactionSuccess:result];
        }
    }];
}

- (IBAction)clickpayHelpPressed:(UIButton *)sender {
    VTClickpayGuideController *help = [[VTClickpayGuideController alloc] initWithNibName:@"VTClickpayGuideController" bundle:VTBundle];
    [self.navigationController pushViewController:help animated:YES];
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
