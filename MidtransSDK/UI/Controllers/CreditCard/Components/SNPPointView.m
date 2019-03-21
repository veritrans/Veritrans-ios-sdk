//
//  SNPPointView.m
//  MidtransKit
//
//  Created by Vanbungkring on 3/7/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import "SNPPointView.h"
#import "VTClassHelper.h"

@implementation SNPPointView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.finalAmountTextField.layer.cornerRadius = 3.0f;
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)configureAmountTotal:(MIDPaymentInfo *)info {
    self.totalAmountPriceLabel.text = info.transaction.grossAmount.formattedCurrencyNumber;
}
@end
