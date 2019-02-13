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

@interface VTBillpaySuccessController ()
@property (strong, nonatomic) IBOutlet UILabel *billCodeLabel;
@property (strong, nonatomic) IBOutlet UILabel *transactionTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *amountLabel;
@property (strong, nonatomic) IBOutlet UILabel *orderIdLabel;
@property (strong, nonatomic) IBOutlet UILabel *companyCodeLabel;
@property (strong, nonatomic) IBOutlet UIView *infoView;

@property (nonatomic) VTVATransactionStatusViewModel *statusModel;
@end

@implementation VTBillpaySuccessController

- (instancetype)initWithToken:(MidtransTransactionTokenResponse *)token
            paymentMethodName:(MidtransPaymentListModel *)paymentMethod
                  statusModel:(VTVATransactionStatusViewModel *)statusModel {
    
    self = [[VTBillpaySuccessController alloc] initWithToken:token
                                           paymentMethodName:paymentMethod];
    if (self) {
        self.statusModel = statusModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.navigationItem setHidesBackButton:YES];
    [self showBackButton:NO];
    _amountLabel.text = _statusModel.totalAmount;
    _orderIdLabel.text = _statusModel.orderId;
    _transactionTimeLabel.text = _statusModel.transactionTime;
    _billCodeLabel.text = _statusModel.billpayCode;
    _companyCodeLabel.text = _statusModel.companyCode;
    
    self.title = @"Mandiri Billpay";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveVAPressed:(UIButton *)sender {
    [[UIPasteboard generalPasteboard] setString:_statusModel.billpayCode];
    [self showToastInviewWithMessage:@"Copied to clipboard"];
}

- (IBAction)helpPressed:(UIButton *)sender {
    [self showGuideViewController];
}

- (IBAction)finishPressed:(UIButton *)sender {
    NSDictionary *userInfo = @{TRANSACTION_RESULT_KEY:self.statusModel.transactionResult};
    [[NSNotificationCenter defaultCenter] postNotificationName:TRANSACTION_SUCCESS object:nil userInfo:userInfo];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
