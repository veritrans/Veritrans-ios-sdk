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

@property (nonatomic, readwrite) VTCustomerDetails *customer;
@property (nonatomic, readwrite) NSArray *items;

@end

@implementation VTClickpayController {
    VTMandiriClickpay *_clickpay;
}

+ (instancetype)controllerWithCustomer:(VTCustomerDetails *)customer items:(NSArray *)items {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Midtrans" bundle:VTBundle];
    VTClickpayController *vc = [storyboard instantiateViewControllerWithIdentifier:@"VTClickpayController"];
    vc.customer = customer;
    vc.items = items;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSNumber *grossAmount = [_items itemsPriceAmount];
    
    _clickpay = [VTMandiriClickpay dataWithTransactionAmount:grossAmount];
    
    [_clickpay addObserver:self
                forKeyPath:@"input1"
                   options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld
                   context:nil];
    
    _appliLabel.text = APPLIClickpay;
    _input2Label.text = _clickpay.input2;
    _input3Label.text = _clickpay.input3;
    
    NSNumberFormatter *formatter = [NSNumberFormatter numberFormatterWith:@"vt.number"];
    _amountLabel.text = [NSString stringWithFormat:@"Rp %@", [formatter stringFromNumber:grossAmount]];
    
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
