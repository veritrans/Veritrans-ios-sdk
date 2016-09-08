//
//  MidtransUIButton.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 3/1/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MidtransUIButton.h"
#import "MidtransUIThemeManager.h"

@implementation MidtransUIButton {
    UIView *_bottomBorder;
    UIView *_leftBorder;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setTitleColor:[[MidtransUIThemeManager shared] themeColor] forState:UIControlStateNormal];
    
    if (self.topLine) {
        _bottomBorder = [[UIView alloc] init];
        _bottomBorder.backgroundColor = self.topLineColor;
        [self addSubview:_bottomBorder];
    }
    
    if (self.leftLine) {
        _leftBorder = [[UIView alloc] init];
        _leftBorder.backgroundColor = self.topLineColor;
        [self addSubview:_leftBorder];
    }
    
    self.titleLabel.font = [[MidtransUIThemeManager shared].themeFont fontRegularWithSize:self.titleLabel.font.pointSize];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGRect bounds = self.bounds;
    
    //Calculate offsets from buttons bounds
    CGFloat widthDelta = (44. - bounds.size.width) > 0 ? (44. - bounds.size.width) : 0;
    CGFloat heightDelta = (44. - bounds.size.height) > 0 ? (44. - bounds.size.height) : 0;
    bounds = CGRectInset(bounds, -(widthDelta/2.), -(heightDelta/2.));
    
    return CGRectContainsPoint(bounds, point);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _bottomBorder.frame = CGRectMake(0, 0, self.frame.size.width, 0.5);
    _leftBorder.frame = CGRectMake(0, 0, 0.5, self.frame.size.height);
}

@end
