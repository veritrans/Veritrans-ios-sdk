//
//  SNPPostPaymentFooter.m
//  MidtransKit
//
//  Created by Vanbungkring on 4/17/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import "SNPPostPaymentFooter.h"
#import "VTClassHelper.h"
@implementation SNPPostPaymentFooter

- (void)awakeFromNib {
    [super awakeFromNib];
    self.downloadInstructionButton.layer.borderColor = self.downloadInstructionButton.tintColor.CGColor;
    self.downloadInstructionButton.layer.borderWidth = 1.;
    self.downloadInstructionButton.layer.cornerRadius = 5.;
    [self.downloadInstructionButton setTitle:[VTClassHelper getTranslationFromAppBundleForString:@"donwload.instruction"] forState:UIControlStateNormal];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
