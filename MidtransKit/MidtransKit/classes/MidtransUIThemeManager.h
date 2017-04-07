//
//  MidtransUIThemeManager.h
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 6/19/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MidtransUIFontSource.h"

static NSString *const MidtransUIDidChangeThemeColor = @"MidtransUIDidChangeThemeColor";

@interface MidtransUIThemeManager : NSObject

@property (nonatomic, readonly) MidtransUIFontSource *themeFont;

+ (MidtransUIThemeManager *)shared;

/**
 * Call it once before presenting UI Flow
 */
+ (void)applyCustomThemeColor:(UIColor *)themeColor themeFont:(MidtransUIFontSource *)themeFont;

/*
 Reset theme configuration
 */
+ (void)applyStandardTheme;

/*
 Sync theme color with SNAP theme configuration
 */
+ (void)applySnapThemeColor:(UIColor *)snapColor;

/*
 Get theme color
 */
- (UIColor *)themeColor;

@end
