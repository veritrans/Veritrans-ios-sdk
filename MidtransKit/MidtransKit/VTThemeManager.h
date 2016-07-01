//
//  VTThemeManager.h
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 6/19/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VTFontSource.h"

@interface VTThemeManager : NSObject

@property (nonatomic, readonly) UIColor *themeColor;
@property (nonatomic, readonly) VTFontSource *themeFont;


+ (instancetype)shared;

/**
 * Call it once before presenting UI Flow
 */
+ (void)applyCustomThemeColor:(UIColor *)themeColor themeFont:(VTFontSource *)themeFont;
+ (void)applyStandardTheme;

@end
