//
//  VTDetailedTitleController.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 3/1/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MIdtransUIDetailedTitleController.h"
#import "MidtransUIThemeManager.h"

@interface MIdtransUIDetailedTitleController ()

@end

@implementation MIdtransUIDetailedTitleController {
    UILabel *titleLabel;
    UILabel *descLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *headerView = [UIView new];
    titleLabel = [UILabel new];
    titleLabel.font = [[MidtransUIThemeManager shared].themeFont fontRegularWithSize:15];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    titleLabel.text = self.headerTitle;
    
    descLabel = [UILabel new];
    descLabel.font = [[MidtransUIThemeManager shared].themeFont fontRegularWithSize:11];
    descLabel.textColor = [UIColor blackColor];
    descLabel.textAlignment = NSTextAlignmentCenter;
    descLabel.translatesAutoresizingMaskIntoConstraints = NO;
    descLabel.text = self.headerDescription;
    
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

- (void)setHeaderDescription:(NSString *)headerDescription {
    _headerDescription = headerDescription;
    descLabel.text = headerDescription;
}

- (void)setHeaderTitle:(NSString *)headerTitle {
    _headerTitle = headerTitle;
    titleLabel.text = headerTitle;
}

@end
