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

static NSInteger const MIDTRANS_DEMO_PAYMENT_STATUS_BAR_TAG = 1002;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];
    defaults_observe_object(@"md_color", ^(NSNotification *note) {
        self.navigationBar.tintColor = [UIColor mdThemeColor];
    });
}

- (void)setupNavigationBar {
    self.navigationBar.translucent = NO;
    [self.navigationBar setBackgroundImage:[UIImage new]
                            forBarPosition:UIBarPositionAny
                                barMetrics:UIBarMetricsDefault];
    [self.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:[[UIImage alloc] init]];
    self.navigationBar.tintColor = [[MidtransUIThemeManager shared] themeColor];
    
    if (@available(iOS 15.0, *)) {
        self.navigationBar.backgroundColor = [UIColor whiteColor];
        self.navigationBar.titleTextAttributes = @{NSFontAttributeName:[[MidtransUIThemeManager shared].themeFont fontRegularWithSize:17],
                                                   NSForegroundColorAttributeName:[UIColor colorWithRed:3/255. green:3/255. blue:3/255. alpha:1]};
        UIView * statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, [[UIApplication sharedApplication] statusBarFrame].size.height)];
        statusBarView.backgroundColor = [UIColor whiteColor];
        statusBarView.tag = MIDTRANS_DEMO_PAYMENT_STATUS_BAR_TAG;
        [self.view addSubview:statusBarView];
    } else {
        self.navigationBar.titleTextAttributes = @{NSFontAttributeName:[[MidtransUIThemeManager shared].themeFont fontRegularWithSize:17],
                                                   NSForegroundColorAttributeName:[UIColor colorWithRed:3/255. green:3/255. blue:3/255. alpha:1]};
        self.navigationBar.barTintColor = [UIColor whiteColor];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    if (@available(iOS 13.0, *)) {
        return UIStatusBarStyleDarkContent;
    } else {
        return UIStatusBarStyleDefault;
    }
}

@end
