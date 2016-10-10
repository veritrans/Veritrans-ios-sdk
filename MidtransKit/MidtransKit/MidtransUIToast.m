//
//  MidtransUIToast.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 5/30/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MidtransUIToast.h"

@interface MidtransUIToast()
@property (nonatomic) IBOutlet UILabel *titleLabel;
@end

@implementation MidtransUIToast

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.layer.cornerRadius = 5.0;
    self.translatesAutoresizingMaskIntoConstraints = NO;
}

+ (void)createToast:(NSString *)toast duration:(NSTimeInterval)duration containerView:(UIView *)containerView {
    MidtransUIToast *toastView = [[MidtransUIToast alloc] initWithFrame:CGRectZero];
    [toastView showToast:toast duration:duration containerView:containerView];
}

- (void)showToast:(NSString *)toast duration:(NSTimeInterval)duration containerView:(UIView *)containerView {
    self.alpha = 1;
    
    [containerView addSubview:self];
    
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:0];
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:containerView attribute:NSLayoutAttributeBottom multiplier:1 constant:-16];
    NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:containerView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    
    [containerView addConstraint:height];
    [containerView addConstraint:bottom];
    [containerView addConstraint:centerX];
    
    _titleLabel.text = toast;
    
    [self layoutIfNeeded];
    [self setNeedsLayout];
    
    height.constant = CGRectGetMaxY(_titleLabel.frame) + 8;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (duration-0.5) * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.5 animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
            [self removeConstraints:@[height, bottom, centerX]];
        }];
    });
}

@end
