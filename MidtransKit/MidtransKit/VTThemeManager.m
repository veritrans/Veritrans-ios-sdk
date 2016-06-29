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
@property (nonatomic, assign) CGFontRef semiBoldFontRef;

@property (nonatomic, strong) UIFont *boldFont;
@property (nonatomic, strong) UIFont *lightFont;
@property (nonatomic, strong) UIFont *regularFont;
@property (nonatomic, strong) UIFont *semiBoldFont;
@end

@implementation VTThemeManager

+ (id)shared {
    static VTThemeManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        NSString *filePath = [VTBundle pathForResource:@"SourceSansPro-Bold" ofType:@"ttf"];
        _boldFontRef = [self fontRefFromFile:filePath];
        
        filePath = [VTBundle pathForResource:@"SourceSansPro-Light" ofType:@"ttf"];
        _lightFontRef = [self fontRefFromFile:filePath];
        
        filePath = [VTBundle pathForResource:@"SourceSansPro-Regular" ofType:@"ttf"];
        _regularFontRef = [self fontRefFromFile:filePath];
        
        filePath = [VTBundle pathForResource:@"SourceSansPro-Semibold" ofType:@"ttf"];
        _semiBoldFontRef = [self fontRefFromFile:filePath];
    }
    return self;
}

- (UIColor *)themeColor {
    if (!_themeColor) {
        _themeColor = [UIColor colorWithRed:25/255. green:163/255. blue:239/255. alpha:1.0];
    }
    return _themeColor;
}

- (UIFont *)boldFontWithSize:(NSInteger)size {
    NSString *fontName = (NSString *)CFBridgingRelease(CGFontCopyPostScriptName(_boldFontRef));
    return [UIFont fontWithName:fontName size:size];
}
- (UIFont *)lightFontWithSize:(NSInteger)size {
    NSString *fontName = (NSString *)CFBridgingRelease(CGFontCopyPostScriptName(_lightFontRef));
    return [UIFont fontWithName:fontName size:size];
}
- (UIFont *)regularFontWithSize:(NSInteger)size {
    NSString *fontName = (NSString *)CFBridgingRelease(CGFontCopyPostScriptName(_regularFontRef));
    return [UIFont fontWithName:fontName size:size];
}
- (UIFont *)semiBoldFontWithSize:(NSInteger)size {
    NSString *fontName = (NSString *)CFBridgingRelease(CGFontCopyPostScriptName(_semiBoldFontRef));
    return [UIFont fontWithName:fontName size:size];
}

- (CGFontRef)fontRefFromFile:(NSString *)filePath {
    NSData *inData = [[NSData alloc] initWithContentsOfFile:filePath];
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((CFDataRef)inData);
    CGFontRef fontRef = CGFontCreateWithDataProvider(provider);
    CTFontManagerRegisterGraphicsFont(fontRef, nil);
    return fontRef;
}

+ (void)registerFontFromResource:(NSString *)fontFilePath {
    NSData *inData = [[NSData alloc] initWithContentsOfFile:fontFilePath];
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((CFDataRef)inData);
    CGFontRef fontRef = CGFontCreateWithDataProvider(provider);
    CTFontManagerRegisterGraphicsFont(fontRef, nil);
}

+ (void)registerSourceSansProFonts {
    NSString *filePath = [VTBundle pathForResource:@"SourceSansPro-Bold" ofType:@"ttf"];
    [self registerFontFromResource:filePath];
    
    filePath = [VTBundle pathForResource:@"SourceSansPro-Light" ofType:@"ttf"];
    [self registerFontFromResource:filePath];
    
    filePath = [VTBundle pathForResource:@"SourceSansPro-Regular" ofType:@"ttf"];
    [self registerFontFromResource:filePath];
    
    filePath = [VTBundle pathForResource:@"SourceSansPro-Semibold" ofType:@"ttf"];
    [self registerFontFromResource:filePath];
    
    filePath = [VTBundle pathForResource:@"OCRAEXT" ofType:@"TTF"];
    [self registerFontFromResource:filePath];
}

@end
