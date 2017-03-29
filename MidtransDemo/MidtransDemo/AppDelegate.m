//
//  AppDelegate.m
//  MidtransDemo
//
//  Created by Nanang Rafsanjani on 3/23/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import "AppDelegate.h"
#import "MDOptionsViewController.h"
#import "MDProductViewController.h"
#import "MDUtils.h"
#import "MDNavigationViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"Fonts:\n%@\n%@", [UIFont fontNamesForFamilyName:@"Bariol"], [UIFont fontNamesForFamilyName:@"Source Sans Pro"]);

    MDProductViewController *pvc = [[MDProductViewController alloc] initWithNibName:@"MDProductViewController" bundle:nil];
    MDOptionsViewController *ovc = [[MDOptionsViewController alloc] initWithNibName:@"MDOptionsViewController" bundle:nil];
    MDNavigationViewController *nvc = [MDNavigationViewController new];
    [nvc setViewControllers:@[ovc, pvc]];
    self.window.rootViewController = nvc;
    [self.window makeKeyAndVisible];    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
