//
//  VTKlikbcaSuccessController.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 8/16/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTKlikbcaSuccessController.h"
#import "VTClassHelper.h"
#import "VTKITConstant.h"

#import <MidtransCoreKit/MidtransCoreKit.h>

@interface VTKlikbcaSuccessController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *noteLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *transactionTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *finishButton;

@property (nonatomic) VTPaymentStatusViewModel *successViewModel;
@end

@implementation VTKlikbcaSuccessController

- (instancetype)initWithToken:(MidtransTransactionTokenResponse *)token paymentMethodName:(MidtransPaymentListModel *)paymentMethod viewModel:(VTPaymentStatusViewModel *)viewModel {
    self = [super initWithToken:token paymentMethodName:paymentMethod];
    if (self) {
        self.successViewModel = viewModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = UILocalizedString(@"payment.pending",nil);
    [self.navigationItem setHidesBackButton:YES];
    [self showDismissButton:YES];
    [self showBackButton:NO];
    self.amountLabel.text = self.successViewModel.totalAmount;
    self.orderIdLabel.text = self.successViewModel.orderId;
    self.transactionTimeLabel.text = self.successViewModel.transactionTime;
    
    [self.finishButton setTitle:[NSString stringWithFormat:UILocalizedString(@"payment.finish-button-title",nil), @"KlikBCA"] forState:UIControlStateNormal];
}

- (IBAction)helpPressed:(UIButton *)sender {
    [self showGuideViewController];
}

- (IBAction)finishPressed:(UIButton *)sender {
    NSDictionary *userInfo = @{TRANSACTION_RESULT_KEY:self.successViewModel.transactionResult};
    [[NSNotificationCenter defaultCenter] postNotificationName:TRANSACTION_SUCCESS object:nil userInfo:userInfo];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
