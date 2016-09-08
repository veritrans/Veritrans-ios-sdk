//
//  VTNextStepButton.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 6/29/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTNextStepButton.h"
#import "MidtransUIThemeManager.h"

@implementation VTNextStepButton

- (void)awakeFromNib {
    [super awakeFromNib];    
    [self setBackgroundColor:[[MidtransUIThemeManager shared] themeColor]];
    self.titleLabel.font = [[MidtransUIThemeManager shared].themeFont fontRegularWithSize:self.titleLabel.font.pointSize];
}
@end
