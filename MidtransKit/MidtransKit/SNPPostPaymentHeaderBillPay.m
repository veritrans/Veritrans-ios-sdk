//
//  SNPPostPaymentHeaderBillPay.m
//  MidtransKit
//
//  Created by Vanbungkring on 4/17/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import "SNPPostPaymentHeaderBillPay.h"

@implementation SNPPostPaymentHeaderBillPay

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib {
    [super awakeFromNib];
    self.companyCodeTextField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
    self.expiredTimeBackground.layer.cornerRadius = 5.0f;
    self.companyCodeCopyButton.layer.borderColor = self.vaCopyButton.tintColor.CGColor;
    self.companyCodeCopyButton.layer.borderWidth = 1.;
    self.companyCodeCopyButton.layer.cornerRadius = 5.;
}
@end
