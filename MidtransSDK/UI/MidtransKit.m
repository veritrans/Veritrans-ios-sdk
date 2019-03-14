//
//  MidtransKit.m
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 12/02/19.
//  Copyright © 2019 Midtrans. All rights reserved.
//

#import "MidtransKit.h"
#import "MidtransUIThemeManager.h"
#import "MIDPaymentController.h"
#import "MIDConstants.h"
#import "MIDVendorUI.h"

@implementation MidtransKit

#pragma mark - Initialisation

+ (void)configureClientKey:(NSString *)clientKey
         merchantServerURL:(NSString *)merchantServerURL
               environment:(MIDEnvironment)environment {
    
    [MIDVendorUI shared].environment = environment;
    
    [MIDClient configureClientKey:clientKey
                merchantServerURL:merchantServerURL
                      environment:environment];
    
    [MidtransUIThemeManager applyStandardTheme];
}

+ (void)configureClientKey:(NSString *)clientKey
         merchantServerURL:(NSString *)merchantServerURL
               environment:(MIDEnvironment)environment
                     color:(UIColor *)color
                      font:(MidtransUIFontSource *)font {
    
    [MIDVendorUI shared].environment = environment;
    
    [MIDClient configureClientKey:clientKey
                merchantServerURL:merchantServerURL
                      environment:environment];
    
    [MidtransUIThemeManager applyCustomThemeColor:color themeFont:font];
}

#pragma mark - Presentation

+ (void)presentPaymentPageAt:(UIViewController *)presenter
                 transaction:(MIDCheckoutTransaction *)transaction {
    [self presentPaymentPageAt:presenter
                   transaction:transaction
                       options:nil
                 paymentMethod:MIDPaymentMethodUnknown];
}

+ (void)presentPaymentPageAt:(UIViewController *)presenter
                 transaction:(MIDCheckoutTransaction *)transaction
                     options:(NSArray <NSObject <MIDCheckoutable>*> *_Nullable)options {
    [self presentPaymentPageAt:presenter
                   transaction:transaction
                       options:options
                 paymentMethod:MIDPaymentMethodUnknown];
}

+ (void)presentPaymentPageAt:(UIViewController *)presenter
                 transaction:(MIDCheckoutTransaction *)transaction
                     options:(NSArray <NSObject <MIDCheckoutable>*> *_Nullable)options
               paymentMethod:(MIDPaymentMethod)paymentMethod {
    MIDPaymentController *vc = [[MIDPaymentController alloc] initWithTransaction:transaction
                                                                         options:options
                                                                   paymentMethod:paymentMethod];
    [presenter presentViewController:vc animated:YES completion:nil];
}

#pragma mark - Helper

+ (void)handleGopayURL:(NSURL *)URL {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *param in [URL.query componentsSeparatedByString:@"&"]) {
        NSArray *elts = [param componentsSeparatedByString:@"="];
        if([elts count] < 2) continue;
        [params setObject:[elts lastObject] forKey:[elts firstObject]];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:notifGopayStatus object:params];
}

@end
