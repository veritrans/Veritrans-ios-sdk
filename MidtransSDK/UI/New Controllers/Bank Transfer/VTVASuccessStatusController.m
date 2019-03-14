//
//  VTVASuccessStatusController.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 5/20/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTVASuccessStatusController.h"
#import "MidtransUIButton.h"
#import "VTClassHelper.h"
#import "MidtransUIToast.h"
#import "VTMultiGuideController.h"
#import "VTKITConstant.h"
#import "MIDUITrackingManager.h"
#import <QuartzCore/QuartzCore.h>
#import "MIDConstants.h"

@interface VTVASuccessStatusController ()
@property (strong, nonatomic) IBOutlet UILabel *vaNumberLabel;
@property (strong, nonatomic) IBOutlet UILabel *transactionTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *amountLabel;
@property (strong, nonatomic) IBOutlet UILabel *orderIdLabel;
@property (strong, nonatomic) IBOutlet UIView *infoView;

@property (nonatomic) MIDPaymentResult *result;
@end

@implementation VTVASuccessStatusController

- (instancetype)initWithPaymentMethod:(MIDPaymentDetail *)paymentMethod result:(MIDPaymentResult *)result {
    if (self = [super initWithPaymentMethod:paymentMethod]) {
        self.result = result;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[MIDUITrackingManager shared] trackEventName:@"pg success"];
    // Do any additional setup after loading the view from its nib.
    
    [self.navigationItem setHidesBackButton:YES];
    [self showBackButton:NO];
    self.amountLabel.text = self.result.grossAmount.formattedCurrencyNumber;
    self.orderIdLabel.text = self.result.orderID;
    self.transactionTimeLabel.text = self.result.transactionTime.formattedTransactionTime;
    self.title = self.paymentMethod.title;
    self.vaNumberLabel.text = [self vaNumber];
}

- (NSString *)vaNumber {
    if ([self.result isKindOfClass:[MIDBCABankTransferResult class]]) {
        return ((MIDBCABankTransferResult *) self.result).vaNumber;
    } else if ([self.result isKindOfClass:[MIDPermataBankTransferResult class]]) {
        return ((MIDPermataBankTransferResult *) self.result).vaNumber;
    } else if ([self.result isKindOfClass:[MIDBNIBankTransferResult class]]) {
        return ((MIDBNIBankTransferResult *) self.result).vaNumber;
    }
    return nil;
}

- (IBAction)saveVAPressed:(UIButton *)sender {
    [[UIPasteboard generalPasteboard] setString:[self vaNumber]];
    [MidtransUIToast createToast:[VTClassHelper getTranslationFromAppBundleForString:@"toast.copy-text"] duration:1.5 containerView:self.view];
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
