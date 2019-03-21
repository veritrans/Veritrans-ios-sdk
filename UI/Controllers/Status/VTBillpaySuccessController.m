//
//  VTBillpaySuccessController.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 5/30/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTBillpaySuccessController.h"
#import <QuartzCore/QuartzCore.h>
#import "VTClassHelper.h"
#import "MIDConstants.h"

@interface VTBillpaySuccessController ()
@property (strong, nonatomic) IBOutlet UILabel *billCodeLabel;
@property (strong, nonatomic) IBOutlet UILabel *transactionTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *amountLabel;
@property (strong, nonatomic) IBOutlet UILabel *orderIdLabel;
@property (strong, nonatomic) IBOutlet UILabel *companyCodeLabel;
@property (strong, nonatomic) IBOutlet UIView *infoView;

@property (nonatomic) MIDMandiriBankTransferResult *result;
@end

@implementation VTBillpaySuccessController

- (instancetype)initWithPaymentMethod:(MIDPaymentDetail *)paymentMethod result:(MIDMandiriBankTransferResult *)result {
    if (self = [super initWithPaymentMethod:paymentMethod]) {
        self.result = result;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.navigationItem setHidesBackButton:YES];
    [self showBackButton:NO];
    _amountLabel.text = self.result.grossAmount.formattedCurrencyNumber;
    _orderIdLabel.text = self.result.orderID;
    _transactionTimeLabel.text = self.result.transactionTime.formattedTransactionTime;
    _billCodeLabel.text = self.result.key;
    _companyCodeLabel.text = self.result.code;
    
    self.title = @"Mandiri Billpay";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveVAPressed:(UIButton *)sender {
    [[UIPasteboard generalPasteboard] setString:self.result.key];
    [self showToastInviewWithMessage:@"Copied to clipboard"];
}

- (IBAction)helpPressed:(UIButton *)sender {
    [self showGuideViewController];
}

- (IBAction)finishPressed:(UIButton *)sender {
    NSDictionary *userInfo = @{TRANSACTION_RESULT_KEY:self.result.dictionaryValue};
    [[NSNotificationCenter defaultCenter] postNotificationName:TRANSACTION_SUCCESS object:nil userInfo:userInfo];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
