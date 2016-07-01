//
//  VTNoteTitleLabel.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 6/29/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTNoteTitleLabel.h"
#import "VTThemeManager.h"

@implementation VTNoteTitleLabel

- (void)awakeFromNib {
    [super awakeFromNib];
    self.textColor = [[VTThemeManager shared] themeColor];
}

@end
