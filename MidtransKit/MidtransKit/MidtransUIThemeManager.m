//
//  MidtransUIThemeManager.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 6/19/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MidtransUIThemeManager.h"
#import "VTClassHelper.h"

@interface MidtransUIThemeManager()

@property (nonatomic) UIColor *defaultColor;
@property (nonatomic) UIColor *customColor;
@property (nonatomic) UIColor *snapColor;
@property (nonatomic) MidtransUIFontSource *themeFont;

@end

@implementation MidtransUIThemeManager

+ (MidtransUIThemeManager *)shared {
    static MidtransUIThemeManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (instancetype)init {
    if (self = [super init]) {
        //register font for credit card number
        [MidtransUIFontSource registerFontFromFile:[VTBundle pathForResource:@"OCRAEXT" ofType:@"TTF"]];
        
        //apply default theme
        [self setStandardTheme];
    }
    return self;
}

- (void)setStandardTheme {
    self.snapColor = nil;
    self.customColor = nil;
    
    //set defaul theme color
    self.defaultColor = [UIColor colorWithRed:25/255. green:163/255. blue:239/255. alpha:1.0];
    
    //set default font collection
    self.themeFont =
    [[MidtransUIFontSource alloc] initWithFontPathBold:[VTBundle pathForResource:@"SourceSansPro-Bold" ofType:@"ttf"]
                                       fontPathRegular:[VTBundle pathForResource:@"SourceSansPro-Regular" ofType:@"ttf"]
                                         fontPathLight:[VTBundle pathForResource:@"SourceSansPro-Light" ofType:@"ttf"]];
}

#pragma mark - PUBLIC

+ (void)applyStandardTheme {
    [[MidtransUIThemeManager shared] setStandardTheme];
}

+ (void)applySnapThemeColor:(UIColor *)snapColor {
    [MidtransUIThemeManager shared].snapColor = snapColor;
}

+ (void)applyCustomThemeColor:(UIColor *)themeColor themeFont:(MidtransUIFontSource *)themeFont {
    [MidtransUIThemeManager shared].customColor = themeColor;
    [MidtransUIThemeManager shared].themeFont = themeFont;
}

- (UIColor *)themeColor {
    if (self.customColor) {
        return self.customColor;
    }
    else if (self.snapColor) {
        return self.snapColor;
    }
    else {
        return self.defaultColor;
    }
}

@end
