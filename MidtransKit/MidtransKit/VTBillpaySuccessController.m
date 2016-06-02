//
//  VTBillpaySuccessController.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 5/30/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTBillpaySuccessController.h"
#import "VTVAGuideController.h"
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

@property (nonatomic) VTVATransactionStatusViewModel *viewModel;
@end

@implementation VTBillpaySuccessController

- (instancetype)initWithViewModel:(VTVATransactionStatusViewModel *)viewModel {
    self = [[VTBillpaySuccessController alloc] initWithNibName:@"VTBillpaySuccessController" bundle:VTBundle];
    if (self) {
        self.viewModel = viewModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.hidesBackButton = YES;
    
    _amountLabel.text = _viewModel.totalAmount;
    _orderIdLabel.text = _viewModel.orderId;
    _transactionTimeLabel.text = _viewModel.transactionTime;
    _billCodeLabel.text = _viewModel.billpayCode;
    _companyCodeLabel.text = _viewModel.companyCode;
    
    self.title = @"Mandiri Billpay";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveVAPressed:(UIButton *)sender {
    [[UIPasteboard generalPasteboard] setString:_viewModel.billpayCode];
    [VTToast createToast:@"Copied to clipboard" duration:1.5 containerView:self.view];
}

- (IBAction)helpPressed:(UIButton *)sender {
    VTVAGuideController *vc = [VTVAGuideController controllerWithVAType:_viewModel.vaType];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)finishPressed:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
