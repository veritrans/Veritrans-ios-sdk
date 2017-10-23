//
//  SNPPostPaymentFooter.m
//  MidtransKit
//
//  Created by Vanbungkring on 4/17/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import "SNPPostPaymentFooter.h"
#import "VTClassHelper.h"

@interface SNPPostPaymentFooter()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadingImageConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trailingButtonConstraint;
@end
@implementation SNPPostPaymentFooter

- (void)awakeFromNib {
    [super awakeFromNib];
    self.downloadInstructionButton.layer.borderColor = self.downloadInstructionButton.tintColor.CGColor;
    self.downloadInstructionButton.layer.borderWidth = 1.;
    self.downloadInstructionButton.layer.cornerRadius = 5.;
    [self.downloadInstructionButton setTitle:[VTClassHelper getTranslationFromAppBundleForString:@"donwload.instruction"] forState:UIControlStateNormal];
    self.leadingImageConstraint.constant = (self.leadingImageConstraint.constant + self.trailingButtonConstraint.constant) / 2;
    self.trailingButtonConstraint.constant = self.leadingImageConstraint.constant;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
