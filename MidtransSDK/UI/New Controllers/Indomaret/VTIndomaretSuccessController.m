//
//  VTIndomaretSuccessController.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 6/13/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTIndomaretSuccessController.h"
#import "VTClassHelper.h"
#import <QuartzCore/QuartzCore.h>
#import "VTClassHelper.h"
#import "MidtransSDK.h"
#import "MIDConstants.h"

@interface VTIndomaretSuccessController ()
@property (strong, nonatomic) IBOutlet UILabel *paymentCodeLabel;
@property (strong, nonatomic) IBOutlet UILabel *transactionTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *amountLabel;
@property (strong, nonatomic) IBOutlet UILabel *orderIdLabel;
@property (nonatomic) MIDCStoreResult *result;
@end

@implementation VTIndomaretSuccessController

- (instancetype)initWithResult:(MIDCStoreResult *)result paymentMethod:(MIDPaymentDetail *)paymentMethod {
    if (self = [super initWithPaymentMethod:paymentMethod]) {
        self.result = result;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.amountLabel.text = self.result.grossAmount.formattedCurrencyNumber;
    self.orderIdLabel.text = self.result.orderID;
    self.transactionTimeLabel.text = self.result.expiration;
    self.paymentCodeLabel.text = self.result.paymentCode;

    self.title = [NSString stringWithFormat:[VTClassHelper getTranslationFromAppBundleForString:@"payment.pay-at"], [self.paymentMethod.paymentID capitalizedString]];

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
    NSDictionary *userInfo = @{TRANSACTION_RESULT_KEY:self.result.dictionaryValue};
    [[NSNotificationCenter defaultCenter] postNotificationName:TRANSACTION_SUCCESS object:nil userInfo:userInfo];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
