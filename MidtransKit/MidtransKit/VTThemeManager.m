//
//  VTThemeManager.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 6/19/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTThemeManager.h"
#import "VTClassHelper.h"

@interface VTThemeManager()


@property (nonatomic) UIColor *themeColor;
@property (nonatomic) VTFontSource *themeFont;
@end

@implementation VTThemeManager

+ (instancetype)shared {
    static VTThemeManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (instancetype)init {
    if (self = [super init]) {
        //register font for credit card number
        [VTFontSource registerFontFromFile:[VTBundle pathForResource:@"OCRAEXT" ofType:@"TTF"]];
        
        //apply default theme
        [self applyStandardTheme];
    }
    return self;
}

- (void)applyStandardTheme {
    //set defaul theme color
    self.themeColor = [UIColor colorWithRed:25/255. green:163/255. blue:239/255. alpha:1.0];
    
    //set default font collection
    self.themeFont = [[VTFontSource alloc] initWithFontPathBold:[VTBundle pathForResource:@"SourceSansPro-Bold" ofType:@"ttf"]
                                                fontPathRegular:[VTBundle pathForResource:@"SourceSansPro-Regular" ofType:@"ttf"]
                                                  fontPathLight:[VTBundle pathForResource:@"SourceSansPro-Light" ofType:@"ttf"]];
}

#pragma mark - PUBLIC

+ (void)applyCustomThemeColor:(UIColor *)themeColor themeFont:(VTFontSource *)themeFont {
    [VTThemeManager shared].themeColor = themeColor;
    [VTThemeManager shared].themeFont = themeFont;
}

@end
