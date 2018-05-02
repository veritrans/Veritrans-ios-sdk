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
#import <Crashlytics/Crashlytics.h>
#import "MDNavigationViewController.h"
#import "MDOptionManager.h"
#import <Fabric/Fabric.h>
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"USER_DEMO_CONTENT_FIRST_NAME"] length]<1) {
        [[NSUserDefaults standardUserDefaults] setObject:@"Budi" forKey:@"USER_DEMO_CONTENT_FIRST_NAME"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"USER_DEMO_CONTENT_LAST_NAME"] length]<1) {
        [[NSUserDefaults standardUserDefaults] setObject:@"Utomo" forKey:@"USER_DEMO_CONTENT_LAST_NAME"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"USER_DEMO_CONTENT_PHONE"] length]<1) {
        [[NSUserDefaults standardUserDefaults] setObject:@"0812222222222" forKey:@"USER_DEMO_CONTENT_PHONE"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"USER_DEMO_CONTENT_EMAIL"] length]<1) {
        [[NSUserDefaults standardUserDefaults] setObject:@"demo.midtrans@midtrans.com" forKey:@"USER_DEMO_CONTENT_EMAIL"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"USER_DEMO_CONTENT_ADDRESS"] length]<1) {
        [[NSUserDefaults standardUserDefaults] setObject:@"MidPlaza 2, 4th Floor Jl. Jend. Sudirman Kav.10-11" forKey:@"USER_DEMO_CONTENT_ADDRESS"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"USER_DEMO_CONTENT_CITY"] length]<1) {
        [[NSUserDefaults standardUserDefaults] setObject:@"Jakarta" forKey:@"USER_DEMO_CONTENT_CITY"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"USER_DEMO_CONTENT_POSTAL_CODE"] length]<1) {
        [[NSUserDefaults standardUserDefaults] setObject:@"10220" forKey:@"USER_DEMO_CONTENT_POSTAL_CODE"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"USER_DEMO_CONTENT_COUNTRY"] length]<1) {
        [[NSUserDefaults standardUserDefaults] setObject:@"IDN" forKey:@"USER_DEMO_CONTENT_COUNTRY"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    /*
     address:@"MidPlaza 2, 4th Floor Jl. Jend. Sudirman Kav.10-11"
     city:@"Jakarta"
     postalCode:@"10220"
     countryCode:@"IDN"];
     */
    [MDOptionManager shared];
    
    [Fabric with:@[[Crashlytics class]]];
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
