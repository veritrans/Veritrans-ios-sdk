//
//  VTNoteTitleLabel.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 6/29/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTNoteTitleLabel.h"
#import "MidtransUIThemeManager.h"

@implementation VTNoteTitleLabel

- (void)awakeFromNib {
    [super awakeFromNib];
    self.textColor = [[MidtransUIThemeManager shared] themeColor];
}

@end
