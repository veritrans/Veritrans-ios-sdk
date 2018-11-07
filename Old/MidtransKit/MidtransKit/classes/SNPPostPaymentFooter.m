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
@end
@implementation SNPPostPaymentFooter

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.downloadInstructionButton setTitle:[VTClassHelper getTranslationFromAppBundleForString:@"download.instruction"] forState:UIControlStateNormal];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
