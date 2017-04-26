//
//  MidtransUINextStepButton.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 6/29/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MidtransUINextStepButton.h"
#import "MidtransUIThemeManager.h"

@implementation MidtransUINextStepButton

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.accessibilityIdentifier = @"mt_finish_btn";
    
    [self setBackgroundColor:[[MidtransUIThemeManager shared] themeColor]];
    self.titleLabel.font = [[MidtransUIThemeManager shared].themeFont fontRegularWithSize:self.titleLabel.font.pointSize];
}
@end
