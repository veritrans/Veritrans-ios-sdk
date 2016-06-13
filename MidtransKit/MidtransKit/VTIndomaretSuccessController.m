//
//  VTIndomaretSuccessController.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 6/13/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTIndomaretSuccessController.h"
#import "VTClassHelper.h"
#import "VTIndomaretGuideController.h"
#import <QuartzCore/QuartzCore.h>
#import "VTClassHelper.h"
#import "VTToast.h"

@interface VTIndomaretSuccessController ()
@property (nonatomic) VTPaymentStatusViewModel *viewModel;

@property (strong, nonatomic) IBOutlet UILabel *paymentCodeLabel;
@property (strong, nonatomic) IBOutlet UILabel *transactionTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *amountLabel;
@property (strong, nonatomic) IBOutlet UILabel *orderIdLabel;

@end

@implementation VTIndomaretSuccessController

- (instancetype)initWithViewModel:(VTPaymentStatusViewModel *)viewModel {
    self = [[VTIndomaretSuccessController alloc] initWithNibName:@"VTIndomaretSuccessController" bundle:VTBundle];
    if (self) {
        self.viewModel = viewModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.    
    
    _amountLabel.text = _viewModel.totalAmount;
    _orderIdLabel.text = _viewModel.orderId;
    _transactionTimeLabel.text = _viewModel.transactionTime;
    _paymentCodeLabel.text = _viewModel.transactionResult.additionalData[@"payment_code"];
    
    self.title = @"Pay at Indomaret";
}

- (IBAction)copyCodePressed:(UIButton *)sender {
    [[UIPasteboard generalPasteboard] setString:_paymentCodeLabel.text];
    [VTToast createToast:@"Copied to clipboard" duration:1.5 containerView:self.view];
}

- (IBAction)helpPressed:(UIButton *)sender {
    VTIndomaretGuideController *vc = [[VTIndomaretGuideController alloc] initWithNibName:@"VTIndomaretGuideController" bundle:VTBundle];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)finishPressed:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
