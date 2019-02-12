//
//  VTPaymentGeneralView.m
//  MidtransKit
//
//  Created by Arie on 6/18/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MidtransUIPaymentGeneralView.h"
#import "MidtransUINextStepButton.h"
#import "VTClassHelper.h"
@implementation MidtransUIPaymentGeneralView
- (void)awakeFromNib {
    [super awakeFromNib];
    self.tokenViewLabel.text = [VTClassHelper getTranslationFromAppBundleForString:@"Key token device is required for this payment method"];
    self.totalAmountLabelText.text = [VTClassHelper getTranslationFromAppBundleForString:@"total.amount"];
    [self.confirmPaymentButton setTitle:[VTClassHelper getTranslationFromAppBundleForString:@"confirm.payment"] forState:UIControlStateNormal];
}
@end
