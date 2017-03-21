//
//  AppDelegate.m
//  VTDirectDemo
//
//  Created by Nanang Rafsanjani on 2/16/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "AppDelegate.h"

#import <MidtransKit/MidtransKit.h>

#import "OptionViewController.h"
//40ae30db-319b-4fb3-9753-aa5f0f031bcf
static NSString * const kClientKey = @"client_key";
static NSString * const kMerchantURL = @"merchant_url";
static NSString * const kEnvironment = @"environment";
static NSString * const kTimeoutInterval = @"timeout_interval";

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    id environment = [[NSUserDefaults standardUserDefaults] valueForKey:kEnvironment];
    if (!environment) {
        environment = @"0";
        [[NSUserDefaults standardUserDefaults] setObject:environment forKey:kEnvironment];
    }
    
    id clientKey = [[NSUserDefaults standardUserDefaults] valueForKey:kClientKey];
    if (!clientKey) {
        clientKey = @"VT-client-E4f1bsi1LpL1p5cF";
        [[NSUserDefaults standardUserDefaults] setObject:clientKey forKey:kClientKey];
    }
    
    id merchantURL = [[NSUserDefaults standardUserDefaults] valueForKey:kMerchantURL];
    if (!merchantURL) {
        merchantURL = @"https://rakawm-snap.herokuapp.com/";
        [[NSUserDefaults standardUserDefaults] setObject:merchantURL forKey:kMerchantURL];
    }
    
    NSNumber *timeout = [[NSUserDefaults standardUserDefaults] valueForKey:kTimeoutInterval];
    if (!timeout) {
        timeout = @20;
        [[NSUserDefaults standardUserDefaults] setObject:timeout forKey:kTimeoutInterval];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [CONFIG setClientKey:@"VT-client-E4f1bsi1LpL1p5cF"
             environment:MidtransServerEnvironmentSandbox
       merchantServerURL:@"https://rakawm-snap.herokuapp.com/installment"];
    
    //    [CONFIG setClientKey:@"VT-client-E4f1bsi1LpL1p5cF"
    //             environment:MidtransServerEnvironmentSandbox
    //       merchantServerURL:@"https://rakawm-snap.herokuapp.com/installment"];
    
    //    [CONFIG setClientKey:@"VT-client-EyRaL8UEMwjlCzyW"
    //             environment:MidtransServerEnvironmentStaging
    //       merchantServerURL:@"https://echo.dev.kfit.ninja/api/fave/v2/cities/jakarta/veritrans/"];
    
    //set credit card config
    id ccPaymentType = [[NSUserDefaults standardUserDefaults] objectForKey:kOptionViewControllerCCType];
    if (!ccPaymentType) {
        ccPaymentType = @(MTCreditCardPaymentTypeNormal);
    }
    CC_CONFIG.paymentType = [ccPaymentType integerValue];
    
    id secureCreditCard = [[NSUserDefaults standardUserDefaults] objectForKey:kOptionViewControllerCCSecure];
    if (!secureCreditCard) {
        secureCreditCard = @NO;
    }
    CC_CONFIG.secure3DEnabled = [secureCreditCard boolValue];
    
    id tokenStorage = [[NSUserDefaults standardUserDefaults] objectForKey:kOptionViewControllerCCTokenStorage];
    if (!tokenStorage) {
        tokenStorage = @NO;
    }
    CC_CONFIG.tokenStorageEnabled = [tokenStorage boolValue];
    
    id saveCard = [[NSUserDefaults standardUserDefaults] objectForKey:kOptionViewControllerCCSaveCard];
    if (!saveCard) {
        saveCard = @NO;
    }
    CC_CONFIG.saveCardEnabled = YES;
    
    id acquiringBank = [[NSUserDefaults standardUserDefaults] objectForKey:kOptionViewControllerCCAcquiringBank];
    if (!acquiringBank) {
        acquiringBank = @{@"type":@(MTAcquiringBankMandiri), @"string":@"Mandiri"};
    }
    CC_CONFIG.acquiringBank = [acquiringBank[@"type"] integerValue];
    
    id promoEngine = [[NSUserDefaults standardUserDefaults] objectForKey:kOptionViewControllerPromoEngine];
    if (!promoEngine) {
        promoEngine = @NO;
    }
    CC_CONFIG.promoEnabled = [promoEngine boolValue];
        
    id preauth = [[NSUserDefaults standardUserDefaults] objectForKey:kOptionViewControllerPreauth];
    if (!preauth) {
        preauth = @NO;
    }
    CC_CONFIG.preauthEnabled = [preauth boolValue];
    
    CC_CONFIG.setDefaultCreditSaveCardEnabled = YES;
    
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
