//
//  MIDViewHelper.m
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 04/03/19.
//  Copyright © 2019 Midtrans. All rights reserved.
//

#import "MIDViewHelper.h"

@implementation MIDViewHelper

@end

@implementation UIApplication (Utils)

+ (UIViewController *)rootViewController {
    UIViewController *topRootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topRootViewController.presentedViewController) {
        if (![topRootViewController.presentedViewController isKindOfClass:[UIAlertController class]]) {
            topRootViewController = topRootViewController.presentedViewController;
        }
        else {
            break;
        }
    }
    if (!topRootViewController || [topRootViewController isKindOfClass:[UINavigationController class]] || [topRootViewController isKindOfClass:[UITabBarController class]]) {
        
        if (!topRootViewController) {
            topRootViewController = [[[[UIApplication sharedApplication]delegate]window]rootViewController];
        }
        
        if ([topRootViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController* navController = (UINavigationController*)topRootViewController;
            return navController.topViewController;
        }
        else if ([topRootViewController isKindOfClass:[UITabBarController class]]) {
            
            UITabBarController* tabController = (UITabBarController*)topRootViewController;
            
            if ([tabController.selectedViewController isKindOfClass:[UINavigationController class]]) {
                UINavigationController* navController = (UINavigationController*)tabController.selectedViewController;
                return navController.topViewController;
            }
            else {
                return tabController.selectedViewController;
            }
        }
        else {
            return topRootViewController;
        }
    }
    return topRootViewController;
}

@end
