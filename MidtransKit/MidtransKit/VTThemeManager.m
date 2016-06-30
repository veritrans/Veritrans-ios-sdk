//
//  VTThemeManager.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 6/19/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTThemeManager.h"
#import <CoreText/CoreText.h>
#import "VTClassHelper.h"

@interface VTThemeManager()
@property (nonatomic, assign) CGFontRef boldFontRef;
@property (nonatomic, assign) CGFontRef lightFontRef;
@property (nonatomic, assign) CGFontRef regularFontRef;

@property (nonatomic) UIColor *themeColor;
@property (nonatomic) VTFontSource *fontSource;
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
        [self registerFontFromFile:[VTBundle pathForResource:@"OCRAEXT" ofType:@"TTF"]];
    }
    return self;
}

- (void)setFontSource:(VTFontSource *)fontSource {
    _fontSource = fontSource;
    
    self.boldFontRef = [self registerFontFromFile:fontSource.fontBoldPath];
    self.regularFontRef = [self registerFontFromFile:fontSource.fontRegularPath];
    self.lightFontRef = [self registerFontFromFile:fontSource.fontLightPath];
}

- (NSString *)boldFontName {
    return (NSString *)CFBridgingRelease(CGFontCopyPostScriptName(self.boldFontRef));
}
- (NSString *)regularFontName {
    return (NSString *)CFBridgingRelease(CGFontCopyPostScriptName(self.regularFontRef));
}
- (NSString *)lightFontName {
    return (NSString *)CFBridgingRelease(CGFontCopyPostScriptName(self.lightFontRef));
}

- (UIFont *)boldFontWithSize:(NSInteger)size {
    return [UIFont fontWithName:self.boldFontName size:size];
}
- (UIFont *)lightFontWithSize:(NSInteger)size {
    return [UIFont fontWithName:self.lightFontName size:size];
}
- (UIFont *)regularFontWithSize:(NSInteger)size {
    return [UIFont fontWithName:self.regularFontName size:size];
}

- (CGFontRef)registerFontFromFile:(NSString *)filePath {
    NSData *inData = [[NSData alloc] initWithContentsOfFile:filePath];
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((CFDataRef)inData);
    CGFontRef fontRef = CGFontCreateWithDataProvider(provider);
    CTFontManagerRegisterGraphicsFont(fontRef, nil);
    return fontRef;
}

+ (void)applyCustomThemeColor:(UIColor *)themeColor fontSource:(VTFontSource *)fontSource {
    [VTThemeManager shared].themeColor = themeColor;
    [VTThemeManager shared].fontSource = fontSource;
}

+ (void)applyStandardTheme {
    //set defaul theme color
    [VTThemeManager shared].themeColor = [UIColor colorWithRed:25/255. green:163/255. blue:239/255. alpha:1.0];
    
    //set default font collection
    [VTThemeManager shared].fontSource =
    [[VTFontSource alloc] initWithBoldFontPath:[VTBundle pathForResource:@"SourceSansPro-Bold" ofType:@"ttf"]
                               regularFontPath:[VTBundle pathForResource:@"SourceSansPro-Regular" ofType:@"ttf"]
                                 lightFontPath:[VTBundle pathForResource:@"SourceSansPro-Light" ofType:@"ttf"]];
}

@end
