//
//  VTSuccessStatusController.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 3/7/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTSuccessStatusController.h"
#import "VTClassHelper.h"
#import <MidtransCoreKit/MidtransCoreKit.h>

@interface VTSuccessStatusController ()
@property (weak, nonatomic) IBOutlet UIImageView *statusIconView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *transactionTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *paymentTypeLabel;
@property (weak, nonatomic) IBOutlet UIButton *finishButton;

@property (nonatomic) VTPaymentStatusViewModel *successViewModel;
@end

@implementation VTSuccessStatusController

+ (instancetype)controllerWithSuccessViewModel:(VTPaymentStatusViewModel *)viewModel {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Midtrans" bundle:VTBundle];
    VTSuccessStatusController *vc = [storyboard instantiateViewControllerWithIdentifier:@"VTSuccessStatusController"];
    vc.successViewModel = viewModel;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = UILocalizedString(@"payment.success",nil);
    [self.navigationItem setHidesBackButton:YES];
    
    _amountLabel.text = _successViewModel.totalAmount;
    _orderIdLabel.text = _successViewModel.orderId;
    _transactionTimeLabel.text = _successViewModel.transactionTime;
    _paymentTypeLabel.text = _successViewModel.paymentType;
    if ([_successViewModel.paymentType isEqualToString:@"Bca Klikbca"]) {
        [self.finishButton setTitle:[NSString stringWithFormat:UILocalizedString(@"payment.finish-button-title",nil), @"KlikBCA"] forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)finishPressed:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
