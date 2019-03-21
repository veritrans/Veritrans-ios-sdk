//
//  MIDGopayView.m
//  MidtransKit
//
//  Created by Vanbungkring on 11/24/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import "MIDGopayView.h"
#import "VTClassHelper.h"
#import "MidtransUINextStepButton.h"
@implementation MIDGopayView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.finishPaymentButton setTitle:[VTClassHelper getTranslationFromAppBundleForString:@"confirm.payment"] forState:UIControlStateNormal];
      self.totalAmountLabel.text = [VTClassHelper getTranslationFromAppBundleForString:@"total.amount"];
    [self.installGojekButton setTitle:[VTClassHelper getTranslationFromAppBundleForString:@"install.gojek"] forState:UIControlStateNormal];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
