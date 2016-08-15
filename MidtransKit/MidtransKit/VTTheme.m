//
//  VTTheme.m
//  MidtransKit
//
//  Created by Arie on 7/22/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTTheme.h"
#import "VTKITConstant.h"
#import "UIColor+VTColor.h"

@interface VTTheme()
@end

static UIColor *VTThemeDefaultPrimaryBackgroundColor;
static UIColor *VTThemeDefaultSecondaryBackgroundColor;
static UIColor *VTThemeDefaultThemeColor;
static UIColor *VTThemeDefaultErrorColor;
static UIFont  *VTThemeDefaultFont;
static UIFont  *VTThemeDefaultMediumFont;
static UIImage  *VTThemeDefaultLogo;

@implementation VTTheme

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
+ (VTTheme *)defaultTheme {
    static VTTheme  *VTThemeDefaultTheme;
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
