
//  VTKlikbcaSuccessController.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 8/16/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTKlikbcaSuccessController.h"
#import "VTClassHelper.h"
#import "VTKITConstant.h"
#import "MIDConstants.h"

@interface VTKlikbcaSuccessController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *noteLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *transactionTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *finishButton;
@property (weak, nonatomic) IBOutlet UILabel *transactionExpiredTime;
@property (nonatomic) MIDKlikbcaResult *result;
@end

@implementation VTKlikbcaSuccessController

- (instancetype)initWithPaymentMethod:(MIDPaymentDetail *)paymentMethod result:(MIDKlikbcaResult *)result {
    if (self = [super initWithPaymentMethod:paymentMethod]) {
        self.result = result;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [VTClassHelper getTranslationFromAppBundleForString:@"payment.pending"];
    [self.navigationItem setHidesBackButton:YES];
    [self showDismissButton:YES];
    [self showBackButton:NO];
    self.amountLabel.text = self.result.grossAmount.formattedCurrencyNumber;
    self.orderIdLabel.text = self.result.orderID;
    self.transactionTimeLabel.text = self.result.transactionTime.formattedTransactionTime;
    self.transactionExpiredTime.text = self.result.expiration;
    
    [self.finishButton setTitle:[NSString stringWithFormat:[VTClassHelper getTranslationFromAppBundleForString:@"payment.finish-button-title-via"], @"KlikBCA"] forState:UIControlStateNormal];
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
