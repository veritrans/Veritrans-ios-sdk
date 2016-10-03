//
//  VTSegmentedControl.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 6/29/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTSegmentedControl.h"
#import "MidtransUIThemeManager.h"

@implementation VTSegmentedControl

- (void)awakeFromNib {
    [super awakeFromNib];
    self.tintColor = [[MidtransUIThemeManager shared] themeColor];
}

@end
