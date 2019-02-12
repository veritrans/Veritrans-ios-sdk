//
//  VTTheme.m
//  MidtransKit
//
//  Created by Arie on 7/22/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MidtransUITheme.h"
#import "VTKITConstant.h"
#import "UIColor+VTColor.h"

@interface MidtransUITheme()
@end

static UIColor *VTThemeDefaultPrimaryBackgroundColor;
static UIColor *VTThemeDefaultSecondaryBackgroundColor;
static UIColor *VTThemeDefaultThemeColor;
static UIColor *VTThemeDefaultErrorColor;
static UIFont  *VTThemeDefaultFont;
static UIFont  *VTThemeDefaultMediumFont;
static UIImage  *VTThemeDefaultLogo;

@implementation MidtransUITheme

- (void)setSmallFont:(UIFont *)smallFont {
    _smallFont = smallFont;
}
- (void)setLargeFont:(UIFont *)largeFont {
    _largeFont = largeFont;
}
- (void)setPrimaryBackgroundColor:(UIColor *)primaryBackgroundColor {
    _primaryBackgroundColor = primaryBackgroundColor;
}
- (void)setSecondaryBackgroundColor:(UIColor *)secondaryBackgroundColor {
    _secondaryBackgroundColor = secondaryBackgroundColor;
}
- (void)setErrorColor:(UIColor *)errorColor {
    _errorColor = errorColor;
}
- (void)setLogo:(UIImage *)logo {
    _logo = logo;
}

+(void)initialize {
    VTThemeDefaultPrimaryBackgroundColor = [UIColor colorWithRed:242.0f/255.0f green:242.0f/255.0f blue:245.0f/255.0f alpha:1];
    VTThemeDefaultSecondaryBackgroundColor = [UIColor whiteColor];
    VTThemeDefaultThemeColor = [UIColor VTSkyBlue];
    VTThemeDefaultErrorColor = [UIColor VTAppleRed];
    VTThemeDefaultFont = [UIFont fontWithName:FONT_NAME_DEFAULT size:17];
    VTThemeDefaultLogo = [UIImage new];
    if ([UIFont respondsToSelector:@selector(systemFontOfSize:weight:)]) {
        VTThemeDefaultMediumFont = [UIFont systemFontOfSize:17.0f weight:0.2f] ?: [UIFont boldSystemFontOfSize:17];
    } else {
        VTThemeDefaultMediumFont = [UIFont boldSystemFontOfSize:17];
    }
}
+ (MidtransUITheme *)defaultTheme {
    static MidtransUITheme  *VTThemeDefaultTheme;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        VTThemeDefaultTheme = [self new];
    });
    return VTThemeDefaultTheme;
}
- (UIColor *)themeColor {
    return _themeColor ?_themeColor: VTThemeDefaultThemeColor;
}
- (UIFont *)font {
    return _font ?_font: VTThemeDefaultFont;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        _primaryBackgroundColor = VTThemeDefaultPrimaryBackgroundColor;
        _secondaryBackgroundColor = VTThemeDefaultSecondaryBackgroundColor;
        _themeColor = VTThemeDefaultThemeColor;
        _errorColor = VTThemeDefaultErrorColor;
        _font = VTThemeDefaultFont;
        _logo = VTThemeDefaultLogo;
    }
    return self;
}

@end
