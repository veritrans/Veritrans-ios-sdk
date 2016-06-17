//
//  AppDelegate.m
//  VTDirectDemo
//
//  Created by Nanang Rafsanjani on 2/16/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "AppDelegate.h"

#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

#import <MidtransKit/MidtransKit.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

//#define RELEASE

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [Fabric with:@[[Crashlytics class]]];
    
#ifdef RELEASE
    [VTConfig setClientKey:@"d4b273bc-201c-42ae-8a35-c9bf48c1152b"
         merchantServerURL:@"https://vt-merchant.coralshop.top/api-prod"
         serverEnvironment:VTServerEnvironmentProduction];
#else
    [VTConfig setClientKey:@"VT-client-wRhLUazn8LGHLP6Q"
         merchantServerURL:@"https://vt-merchant.coralshop.top/api"
         serverEnvironment:VTServerEnvironmentSandbox];
#endif
    
    BOOL enableOneclick = [[[NSUserDefaults standardUserDefaults] objectForKey:@"enable_oneclick"] boolValue];
    [[VTCardControllerConfig sharedInstance] setEnableOneClick:enableOneclick];
    
    BOOL enable3ds = [[[NSUserDefaults standardUserDefaults] objectForKey:@"enable_3ds"] boolValue];
    [[VTCardControllerConfig sharedInstance] setEnable3DSecure:enable3ds];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
