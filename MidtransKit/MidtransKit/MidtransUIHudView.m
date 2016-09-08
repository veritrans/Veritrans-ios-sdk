//
//  VTHudView.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 3/14/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MidtransUIHudView.h"

@implementation MidtransUIHudView {
    UIView *_roundedView;
    UIActivityIndicatorView *_indicatorView;
}
- (id)init {
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)dealloc {
    
}

- (void)commonInit {
    self.backgroundColor = [UIColor clearColor];
    
    _roundedView = [UIView new];
    _roundedView.translatesAutoresizingMaskIntoConstraints = NO;
    _roundedView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    _roundedView.layer.cornerRadius = 15;
    
    [self addSubview:_roundedView];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_roundedView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_roundedView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_roundedView attribute:NSLayoutAttributeWidth relatedBy:0 toItem:0 attribute:0 multiplier:1 constant:100]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_roundedView attribute:NSLayoutAttributeHeight relatedBy:0 toItem:0 attribute:0 multiplier:1 constant:100]];
    
    _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _indicatorView.translatesAutoresizingMaskIntoConstraints = NO;
    [_roundedView addSubview:_indicatorView];
    [_roundedView addConstraint:[NSLayoutConstraint constraintWithItem:_indicatorView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_roundedView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [_roundedView addConstraint:[NSLayoutConstraint constraintWithItem:_indicatorView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_roundedView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
}

- (void)showOnView:(UIView *)presenterView {
    [_indicatorView startAnimating];
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    [presenterView addSubview:self];
    [presenterView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[hud]|" options:0 metrics:0 views:@{@"hud":self}]];
    [presenterView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[hud]|" options:0 metrics:0 views:@{@"hud":self}]];
}

- (void)hide {
    [_indicatorView stopAnimating];
    
    [self removeFromSuperview];
}

@end
