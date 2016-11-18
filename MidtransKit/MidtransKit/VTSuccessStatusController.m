//
//  VTSuccessStatusController.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 3/7/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTSuccessStatusController.h"
#import "VTClassHelper.h"
#import "VTKITConstant.h"

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

- (instancetype)initWithSuccessViewModel:(VTPaymentStatusViewModel *)viewModel {
    self = [[VTSuccessStatusController alloc] initWithNibName:@"VTSuccessStatusController" bundle:VTBundle];
    if (self) {
        self.successViewModel = viewModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = UILocalizedString(@"payment.success",nil);
    [self.navigationItem setHidesBackButton:YES];

    self.amountLabel.text = self.successViewModel.totalAmount;
    self.orderIdLabel.text = self.successViewModel.orderId;
    self.transactionTimeLabel.text = self.successViewModel.transactionTime;
    self.paymentTypeLabel.text = self.successViewModel.paymentType;
    if ([self.successViewModel.paymentType isEqualToString:@"Bca Klikbca"]) {
        [self.finishButton setTitle:[NSString stringWithFormat:UILocalizedString(@"payment.finish-button-title",nil), @"KlikBCA"] forState:UIControlStateNormal];
    }
}

- (IBAction)finishPressed:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
