//
//  VTPendingStatusController.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 8/29/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTPendingStatusController.h"
#import "MidtransUIButton.h"
#import "VTClassHelper.h"
#import "MidtransUIToast.h"
#import "VTKITConstant.h"
#import "MidtransUINextStepButton.h"

NSString *const kVTPendingStatusControllerPaymentCode = @"payment_code";
NSString *const kVTPendingStatusControllerKiosonExpireTime = @"kioson_expire_time";

@interface VTPendingStatusController ()
@property (strong, nonatomic) IBOutlet UILabel *paymentCodeTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *paymentCodeLabel;
@property (strong, nonatomic) IBOutlet UILabel *expiryDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *amountLabel;
@property (strong, nonatomic) IBOutlet UILabel *orderIDLabel;
@property (strong, nonatomic) IBOutlet MidtransUIButton *paymentGuideButton;
@property (strong, nonatomic) IBOutlet MidtransUIButton *codeCopyButton;
@property (strong, nonatomic) IBOutlet MidtransUINextStepButton *finishButton;

@property (nonatomic) MidtransTransactionResult *result;
@end

@implementation VTPendingStatusController


- (instancetype)initWithToken:(MidtransTransactionTokenResponse *)token paymentMethodName:(MidtransPaymentListModel *)paymentMethod result:(MidtransTransactionResult *)result {
    if (self = [super initWithToken:token paymentMethodName:paymentMethod]) {
        self.result = result;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[SNPUITrackingManager shared] trackEventName:@"pg pending"];
    self.title = UILocalizedString(@"payment.pending",nil);
    self.amountLabel.text = self.result.grossAmount.formattedCurrencyNumber;
    self.orderIDLabel.text = self.result.orderId;
    self.expiryDateLabel.text = self.result.additionalData[kVTPendingStatusControllerKiosonExpireTime];
    self.paymentCodeLabel.text = self.result.additionalData[kVTPendingStatusControllerPaymentCode];
    
    if ([self.paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_KIOS_ON]) {
        self.paymentCodeTitleLabel.text = UILocalizedString(@"kioson.pending.code-title", nil);
        [self.paymentGuideButton setTitle:UILocalizedString(@"kioson.pending.howto-title", nil) forState:UIControlStateNormal];
        [self.codeCopyButton setTitle:UILocalizedString(@"kioson.pending.copy-title", nil) forState:UIControlStateNormal];
    }
    
    [self.paymentGuideButton addTarget:self action:@selector(guidePressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.codeCopyButton addTarget:self action:@selector(copyCodePressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.finishButton addTarget:self action:@selector(finishPressed:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)copyCodePressed:(UIButton *)sender {
    [[UIPasteboard generalPasteboard] setString:self.paymentCodeLabel.text];
    [MidtransUIToast createToast:UILocalizedString(@"toast.copy-text",nil) duration:1.5 containerView:self.view];
}

- (void)guidePressed:(UIButton *)sender {
    [self showGuideViewController];
}

- (void)finishPressed:(UIButton *)sender {
    NSDictionary *userInfo = @{TRANSACTION_RESULT_KEY:self.result};
    [[NSNotificationCenter defaultCenter] postNotificationName:TRANSACTION_SUCCESS object:nil userInfo:userInfo];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
