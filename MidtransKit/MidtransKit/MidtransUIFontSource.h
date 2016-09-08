//
//  VTFontCollection.h
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 6/30/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MidtransUIFontSource : NSObject

@property (nonatomic, readonly) NSString *fontNameBold;
@property (nonatomic, readonly) NSString *fontNameRegular;
@property (nonatomic, readonly) NSString *fontNameLight;

- (instancetype)initWithFontNameBold:(NSString *)fontNameBold
                     fontNameRegular:(NSString *)fontNameRegular
                       fontNameLight:(NSString *)fontNameLight;

- (instancetype)initWithFontPathBold:(NSString *)fontPathBold
                     fontPathRegular:(NSString *)fontPathRegular
                       fontPathLight:(NSString *)fontPathLight;

- (UIFont *)fontBoldWithSize:(NSInteger)size;
- (UIFont *)fontLightWithSize:(NSInteger)size;
- (UIFont *)fontRegularWithSize:(NSInteger)size;

+ (CGFontRef)registerFontFromFile:(NSString *)filePath;

@end
