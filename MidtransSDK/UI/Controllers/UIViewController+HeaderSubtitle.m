//
//  UIViewController+HeaderSubtitle.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 6/13/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "UIViewController+HeaderSubtitle.h"
#import "MidtransUIThemeManager.h"
#import "VTClassHelper.h"

@implementation UIViewController (HeaderSubtitle)

- (void)setHeaderWithTitle:(NSString *)title subTitle:(NSString *)subTitle {
    // Do any additional setup after loading the view.
    UILabel *titleLabel;
    UILabel *subTitleLabel;
    
    UIView *contentView = [UIView new];
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    
    titleLabel = [UILabel new];
    titleLabel.font = [[MidtransUIThemeManager shared].themeFont fontRegularWithSize:15];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    titleLabel.text = title;
    
    subTitleLabel = [UILabel new];
    subTitleLabel.font = [[MidtransUIThemeManager shared].themeFont fontRegularWithSize:11];
    subTitleLabel.textColor = [UIColor blackColor];
    subTitleLabel.textAlignment = NSTextAlignmentCenter;
    subTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    subTitleLabel.text = subTitle;
    
    [contentView addSubview:titleLabel];
    [contentView addSubview:subTitleLabel];
    
    CGSize constraint = CGSizeMake(500, CGFLOAT_MAX);
    NSDictionary *metrics = @{@"tHeight":@([title sizeWithFont:titleLabel.font constraint:constraint].height),
                              @"dHeight":@([subTitle sizeWithFont:subTitleLabel.font constraint:constraint].height)};
    NSDictionary *views = @{@"title":titleLabel, @"desc":subTitleLabel};
    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[title]|" options:0 metrics:0 views:views]];
    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[desc]|" options:0 metrics:0 views:views]];
    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[title(tHeight)]-0-[desc(dHeight)]-0-|" options:0 metrics:metrics views:views]];
    
    UIView *headerView = [UIView new];
    [headerView addSubview:contentView];
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:headerView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:headerView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    [self.navigationItem setTitleView:headerView];
    
    NSString *spacesToCenterTheTitle = @"          ";
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:spacesToCenterTheTitle style:UIBarButtonItemStylePlain target:nil action:nil]];
    
    self.navigationItem.titleView.frame = CGRectMake(0, 20, 500, 44);
}

@end
