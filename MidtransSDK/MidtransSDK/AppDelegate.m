//
//  AppDelegate.m
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 07/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import "AppDelegate.h"
#import "MidtransUISDK.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    MidtransUIFontSource *customFont = [[MidtransUIFontSource alloc] initWithFontNameBold:@"SourceSansPro-Bold"
                                                                          fontNameRegular:@"SourceSansPro-Regular"
                                                                            fontNameLight:@"SourceSansPro-Light"];
    
    [MidtransKit configureClientKey:@"VT-client-UlfSUChIo-KM9sne"
                  merchantServerURL:@"https://juki-merchant-server.herokuapp.com/charge/index.php"
                        environment:MIDEnvironmentSandbox
                              color:[UIColor blackColor]
                               font:customFont];
    
    //    [MIDClient configureClientKey:@"VT-client-UlfSUChIo-KM9sne"
    //                merchantServerURL:@"https://juki-merchant-server.herokuapp.com/charge/index.php"
    //                      environment:MIDEnvironmentSandbox];
    
    //    [MIDClient configureClientKey:@"VT-client-E4f1bsi1LpL1p5cF"
    //                merchantServerURL:@"https://rakawm-snap.herokuapp.com"
    //                      environment:MIDEnvironmentSandbox];
    
    //for normal
    //    [MIDClient configureClientKey:@"SB-Mid-client-txZHOj6jPP0_G8En"
    //                merchantServerURL:@"https://dev-mobile-store.herokuapp.com/"
    //                      environment:MIDEnvironmentSandbox];
    
    //for production
    //    [[MIDClient shared] configureClientKey:@"VT-client-yrHf-c8Sxr-ck8tx"
    //                         merchantServerURL:@"https://midtrans-mobile-snap.herokuapp.com"
    //                               environment:MIDEnvironmentProduction];
    
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
