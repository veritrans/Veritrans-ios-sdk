//
//  MDNavigationViewController.m
//  MidtransDemo
//
//  Created by Nanang Rafsanjani on 3/29/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import "MDNavigationViewController.h"
#import "MDUtils.h"
#import "MDOptionManager.h"

@interface MDNavigationViewController ()

@end

@implementation MDNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBar.accessibilityIdentifier = @"demo_navbar";
    
    self.navigationBar.titleTextAttributes = @{
                                               NSFontAttributeName:[UIFont bariolRegularWithSize:21],
                                               NSForegroundColorAttributeName:[UIColor mdDarkColor]
                                               };
    self.navigationBar.translucent = NO;
    self.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationBar.tintColor = [UIColor mdThemeColor];
    
    defaults_observe_object(@"md_color", ^(NSNotification *note) {
        self.navigationBar.tintColor = [UIColor mdThemeColor];
    });
}

@end
