//
//  VTClickpayController.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 2/29/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTClickpayController.h"
#import "VTClassHelper.h"
#import "VTTextField.h"
#import "VTClickpayHelpController.h"

#import <MidtransCoreKit/VTMandiriClickpay.h>

@interface VTClickpayController ()

@property (strong, nonatomic) IBOutlet VTTextField *debitNumberTextField;
@property (strong, nonatomic) IBOutlet VTTextField *tokenTextField;
@property (strong, nonatomic) IBOutlet UILabel *amountLabel;
@property (strong, nonatomic) IBOutlet UILabel *appliLabel;
@property (strong, nonatomic) IBOutlet UILabel *input1Label;
@property (strong, nonatomic) IBOutlet UILabel *input2Label;
@property (strong, nonatomic) IBOutlet UILabel *input3Label;
@property (strong, nonatomic) IBOutlet UIButton *confirmButton;

@end

@implementation VTClickpayController {
    VTMandiriClickpay *_clickpay;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _clickpay = [VTMandiriClickpay dataWithTransactionAmount:self.transactionDetails.grossAmount];
    
    [_clickpay addObserver:self
                forKeyPath:@"input1"
                   options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld
                   context:nil];
    
    _appliLabel.text = APPLIClickpay;
    _input2Label.text = _clickpay.input2;
    _input3Label.text = _clickpay.input3;
    
    NSNumberFormatter *formatter = [NSNumberFormatter indonesianCurrencyFormatter];
    _amountLabel.text = [formatter stringFromNumber:self.transactionDetails.grossAmount];
    
    [_confirmButton addTarget:self action:@selector(confirmPaymentPressed:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)dealloc {
    [_clickpay removeObserver:self forKeyPath:@"input1"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)debitTextFieldChanged:(VTTextField *)sender {
    _clickpay.debitNumber = sender.text;
}

- (void)confirmPaymentPressed:(UIButton *)sender {

}

- (IBAction)clickpayHelpPressed:(UIButton *)sender {
    VTClickpayHelpController *help = [self.storyboard instantiateViewControllerWithIdentifier:@"VTClickpayHelpController"];
    [self.navigationController pushViewController:help animated:YES];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"input1"]) {
        _input1Label.text = _clickpay.input1;
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isNumeric] == NO) {
        return NO;
    }
    return YES;
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
