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
#import "VTToast.h"

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

- (instancetype)initWithCustomerDetails:(VTCustomerDetails *)customerDetails itemDetails:(NSArray<VTItemDetail *> *)itemDetails transactionDetails:(VTTransactionDetails *)transactionDetails paymentMethodName:(VTPaymentListModel *)paymentMethod statusModel:(VTVATransactionStatusViewModel *)statusModel {
    self = [[VTBillpaySuccessController alloc] initWithCustomerDetails:customerDetails itemDetails:itemDetails transactionDetails:transactionDetails paymentMethodName:paymentMethod];
    if (self) {
        self.statusModel = statusModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.hidesBackButton = YES;
    
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
    [VTToast createToast:@"Copied to clipboard" duration:1.5 containerView:self.view];
}

- (IBAction)helpPressed:(UIButton *)sender {
    [self showGuideViewController];
}

- (IBAction)finishPressed:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
