//
//  SNPPostPaymentGeneralHeader.m
//  MidtransKit
//
//  Created by Vanbungkring on 6/12/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import "SNPPostPaymentGeneralHeader.h"

@implementation SNPPostPaymentGeneralHeader

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib {
    [super awakeFromNib];
    self.vaTextField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
    self.expiredTimeBackground.layer.cornerRadius = 5.0f;
    self.vaCopyButton.layer.borderColor = self.vaCopyButton.tintColor.CGColor;
    self.vaCopyButton.layer.borderWidth = 1.;
    self.vaCopyButton.layer.cornerRadius = 5.;
}
@end
