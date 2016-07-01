//
//  VTSegmentedControl.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 6/29/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTSegmentedControl.h"
#import "VTThemeManager.h"

@implementation VTSegmentedControl

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.tintColor = [[VTThemeManager shared] themeColor];
}

@end
