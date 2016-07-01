//
//  VTFontCollection.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 6/30/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTFontSource.h"

#import <CoreText/CoreText.h>

@interface VTFontSource()
@property (nonatomic) NSString *fontNameBold;
@property (nonatomic) NSString *fontNameRegular;
@property (nonatomic) NSString *fontNameLight;
@end

@implementation VTFontSource

- (instancetype)initWithFontNameBold:(NSString *)fontNameBold
                     fontNameRegular:(NSString *)fontNameRegular
                       fontNameLight:(NSString *)fontNameLight
{
    if (self = [super init]) {
        self.fontNameBold = fontNameBold;
        self.fontNameLight = fontNameLight;
        self.fontNameRegular = fontNameRegular;
    }
    return self;
}


- (instancetype)initWithFontPathBold:(NSString *)fontPathBold
                     fontPathRegular:(NSString *)fontPathRegular
                       fontPathLight:(NSString *)fontPathLight
{
    if (self = [super init]){
        self.fontNameBold = [VTFontSource fontNameFromFontPath:fontPathBold];
        self.fontNameRegular = [VTFontSource fontNameFromFontPath:fontPathRegular];
        self.fontNameLight = [VTFontSource fontNameFromFontPath:fontPathLight];
    }
    return self;
}

- (UIFont *)fontBoldWithSize:(NSInteger)size {
    return [UIFont fontWithName:self.fontNameBold size:size];
}
- (UIFont *)fontLightWithSize:(NSInteger)size {
    return [UIFont fontWithName:self.fontNameLight size:size];
}
- (UIFont *)fontRegularWithSize:(NSInteger)size {
    return [UIFont fontWithName:self.fontNameRegular size:size];
}

+ (CGFontRef)registerFontFromFile:(NSString *)filePath {
    NSData *inData = [[NSData alloc] initWithContentsOfFile:filePath];
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((CFDataRef)inData);
    CGFontRef fontRef = CGFontCreateWithDataProvider(provider);
    CTFontManagerRegisterGraphicsFont(fontRef, nil);
    return fontRef;
}

+ (NSString *)fontNameFromFontPath:(NSString *)fontPath {
    CGFontRef fontRef = [VTFontSource registerFontFromFile:fontPath];
    return (NSString *)CFBridgingRelease(CGFontCopyPostScriptName(fontRef));
}

@end
