//
//  VTIndomaretSuccessController.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 6/13/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTIndomaretSuccessController.h"
#import "VTClassHelper.h"
#import <MidtransCoreKit/MidtransCoreKit.h>
#import <QuartzCore/QuartzCore.h>
#import "VTClassHelper.h"

@interface VTIndomaretSuccessController ()
@property (nonatomic) VTPaymentStatusViewModel *statusModel;

@property (strong, nonatomic) IBOutlet UILabel *paymentCodeLabel;
@property (strong, nonatomic) IBOutlet UILabel *transactionTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *amountLabel;
@property (strong, nonatomic) IBOutlet UILabel *orderIdLabel;

@end

@implementation VTIndomaretSuccessController

- (instancetype)initWithToken:(MidtransTransactionTokenResponse *)token
            paymentMethodName:(MidtransPaymentListModel *)paymentMethod
                  statusModel:(VTPaymentStatusViewModel *)statusModel {
    
    self = [[VTIndomaretSuccessController alloc] initWithToken:token
                                             paymentMethodName:paymentMethod];
    if (self) {
        self.statusModel = statusModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.amountLabel.text = self.statusModel.totalAmount;
    self.orderIdLabel.text = self.statusModel.orderId;
    self.transactionTimeLabel.text = self.statusModel.transactionTime;
    self.paymentCodeLabel.text = self.statusModel.transactionResult.indomaretPaymentCode;
    
    self.title = [NSString stringWithFormat:[VTClassHelper getTranslationFromAppBundleForString:@"payment.pay-at"], [MIDTRANS_PAYMENT_INDOMARET capitalizedString]];
    
    [self.navigationItem setHidesBackButton:YES];
}

- (IBAction)copyCodePressed:(UIButton *)sender {
    [[UIPasteboard generalPasteboard] setString:_paymentCodeLabel.text];
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
