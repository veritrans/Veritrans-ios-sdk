//
//  VTButton.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 3/1/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTButton.h"

@implementation VTButton {
    UIView *_bottomBorder;
}

- (void)awakeFromNib {
    if (self.topLine) {
        _bottomBorder = [[UIView alloc] init];
        _bottomBorder.backgroundColor = self.topLineColor;
        [self addSubview:_bottomBorder];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _bottomBorder.frame = CGRectMake(0, 0, self.frame.size.width, 0.5);
}

@end
