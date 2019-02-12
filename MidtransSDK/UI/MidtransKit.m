//
//  MidtransKit.m
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 12/02/19.
//  Copyright © 2019 Midtrans. All rights reserved.
//

#import "MidtransKit.h"
#import "MidtransUIThemeManager.h"

@implementation MidtransKit

+ (void)configureClientKey:(NSString *)clientKey
         merchantServerURL:(NSString *)merchantServerURL
               environment:(MIDEnvironment)environment {

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
    
    [MIDClient configureClientKey:clientKey
                merchantServerURL:merchantServerURL
                      environment:environment];
    
    [MidtransUIThemeManager applyCustomThemeColor:color themeFont:font];
}

@end
