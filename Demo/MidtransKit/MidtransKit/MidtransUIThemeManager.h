//
//  MidtransUIThemeManager.h
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 6/19/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MidtransUIFontSource.h"

@interface MidtransUIThemeManager : NSObject

@property (nonatomic, readonly) UIColor *themeColor;
@property (nonatomic, readonly) MidtransUIFontSource *themeFont;

+ (instancetype)shared;

/**
 * Call it once before presenting UI Flow
 */
+ (void)applyCustomThemeColor:(UIColor *)themeColor themeFont:(MidtransUIFontSource *)themeFont;

@end
