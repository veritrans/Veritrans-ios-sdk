//
//  VTXLTunaiSuccessController.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 8/8/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTXLTunaiSuccessController.h"
#import "VTClassHelper.h"

@interface VTXLTunaiSuccessController ()

@property (strong, nonatomic) IBOutlet UILabel *orderIDLabel;
@property (strong, nonatomic) IBOutlet UILabel *expirationLabel;
@property (strong, nonatomic) IBOutlet UILabel *amountLabel;
@property (strong, nonatomic) IBOutlet UILabel *merchantCodeLabel;

@property (nonatomic) VTPaymentStatusXLTunaiViewModel *viewModel;

@end

@implementation VTXLTunaiSuccessController

- (instancetype)initWithToken:(MidtransTransactionTokenResponse *)token
            paymentMethodName:(MidtransPaymentListModel *)paymentMethod
                  statusModel:(VTPaymentStatusXLTunaiViewModel *)statusModel {
    if (self = [super initWithToken:token paymentMethodName:paymentMethod]) {
        self.viewModel = statusModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [VTClassHelper getTranslationFromAppBundleForString:@"payment.pending"];
    [self.navigationItem setHidesBackButton:YES];
    self.orderIDLabel.text = self.viewModel.xlOrderID;
    self.merchantCodeLabel.text = self.viewModel.xlMerchantID;
    self.expirationLabel.text = self.viewModel.xlExpiration;
    self.amountLabel.text = self.viewModel.totalAmount;
}

- (IBAction)copyCodePressed:(UIButton *)sender {
    [[UIPasteboard generalPasteboard] setString:self.viewModel.xlMerchantID];
    [self showToastInviewWithMessage:@"Copied to clipboard"];
}

- (IBAction)helpPressed:(UIButton *)sender {
    [self showGuideViewController];
}

- (IBAction)finishPressed:(UIButton *)sender {
    NSDictionary *userInfo = @{TRANSACTION_RESULT_KEY:self.viewModel.transactionResult};
    [[NSNotificationCenter defaultCenter] postNotificationName:TRANSACTION_SUCCESS object:nil userInfo:userInfo];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
