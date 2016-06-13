//
//  UIViewController+HeaderSubtitle.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 6/13/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "UIViewController+HeaderSubtitle.h"

@implementation UIViewController (HeaderSubtitle)

- (void)setHeaderWithTitle:(NSString *)title subTitle:(NSString *)subTitle {
    // Do any additional setup after loading the view.
    UILabel *titleLabel;
    UILabel *descLabel;
    
    UIView *headerView = [UIView new];
    titleLabel = [UILabel new];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    titleLabel.text = title;
    
    
    descLabel = [UILabel new];
    descLabel.font = [UIFont systemFontOfSize:11];
    descLabel.textColor = [UIColor blackColor];
    descLabel.textAlignment = NSTextAlignmentCenter;
    descLabel.translatesAutoresizingMaskIntoConstraints = NO;
    descLabel.text = subTitle;
    
    [headerView addSubview:titleLabel];
    [headerView addSubview:descLabel];
    
    NSDictionary *views = @{@"title":titleLabel, @"desc":descLabel};
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[title]|" options:0 metrics:0 views:views]];
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[desc]|" options:0 metrics:0 views:views]];
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[title]-0-[desc]" options:0 metrics:0 views:views]];
    
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:headerView attribute:NSLayoutAttributeCenterY multiplier:1 constant:-6]];
    
    [self.navigationItem setTitleView:headerView];
    
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"          " style:UIBarButtonItemStylePlain target:nil action:nil]];
    
    self.navigationItem.titleView.frame = CGRectMake(0, 20, 500, 44);
}

@end
