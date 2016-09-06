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

#import "OptionViewController.h"

static NSString * const kClientKey = @"client_key";
static NSString * const kMerchantURL = @"merchant_url";
static NSString * const kEnvironment = @"environment";
static NSString * const kTimeoutInterval = @"timeout_interval";

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [Fabric with:@[[Crashlytics class]]];
    
    id environment = [[NSUserDefaults standardUserDefaults] valueForKey:kEnvironment];
    if (!environment) {
        environment = @"0";
        [[NSUserDefaults standardUserDefaults] setObject:environment forKey:kEnvironment];
    }
    
    id clientKey = [[NSUserDefaults standardUserDefaults] valueForKey:kClientKey];
    if (!clientKey) {
        clientKey = @"VT-client-6_dY49SlR_Ph32_1";
        [[NSUserDefaults standardUserDefaults] setObject:clientKey forKey:kClientKey];
    }
    
    id merchantURL = [[NSUserDefaults standardUserDefaults] valueForKey:kMerchantURL];
    if (!merchantURL) {
        merchantURL = @"http://mobile-snap-sandbox.herokuapp.com";
        [[NSUserDefaults standardUserDefaults] setObject:merchantURL forKey:kMerchantURL];
    }
    
    NSNumber *timeout = [[NSUserDefaults standardUserDefaults] valueForKey:kTimeoutInterval];
    if (!timeout) {
        timeout = @20;
        [[NSUserDefaults standardUserDefaults] setObject:timeout forKey:kTimeoutInterval];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [MidtransConfig setClientKey:clientKey serverEnvironment:[environment integerValue] merchantURL:merchantURL];
    
    
    
    
    //set credit card config
    VTCreditCardPaymentType paymentType;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kOptionViewControllerCCType]) {
        paymentType = [[[NSUserDefaults standardUserDefaults] objectForKey:kOptionViewControllerCCType] unsignedIntegerValue];
    }
    else {
        paymentType = VTCreditCardPaymentTypeNormal;
    }
    
    BOOL cardSecure = NO;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kOptionViewControllerCCSecure]) {
        cardSecure = [[[NSUserDefaults standardUserDefaults] objectForKey:kOptionViewControllerCCSecure] boolValue];
    }
    
    [MidtransCreditCardConfig setPaymentType:paymentType secure:cardSecure];
    
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
