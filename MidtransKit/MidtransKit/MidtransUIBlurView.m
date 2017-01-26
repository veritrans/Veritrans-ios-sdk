//
//  MidtransUIBlurView.m
//  MidtransKit
//
//  Created by Vanbungkring on 1/26/17.
//  Copyright © 2017 Veritrans. All rights reserved.
//

#import "MidtransUIBlurView.h"

@implementation MidtransUIBlurView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:.6];
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    NSDictionary *bindings = @{@"currentView" : self};
    self.translatesAutoresizingMaskIntoConstraints = NO;
    if (self.superview) {
        [self.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[currentView]|" options:0 metrics:nil views:bindings]];
        [self.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[currentView]|" options:0 metrics:nil views:bindings]];
    }
}

@end
