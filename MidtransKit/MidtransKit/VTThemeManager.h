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

+ (instancetype)shared;

- (NSString *)boldFontName;
- (NSString *)regularFontName;
- (NSString *)lightFontName;

- (UIFont *)boldFontWithSize:(NSInteger)size;
- (UIFont *)lightFontWithSize:(NSInteger)size;
- (UIFont *)regularFontWithSize:(NSInteger)size;

- (UIColor *)themeColor;

/**
 * Call it once before presenting UI Flow
 */
+ (void)applyCustomThemeColor:(UIColor *)themeColor fontSource:(VTFontSource *)fontSource;
+ (void)applyStandardTheme;

@end
