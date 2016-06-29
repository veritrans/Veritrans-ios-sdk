//
//  VTFontManager.h
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 6/19/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface VTThemeManager : NSObject

@property (nonatomic) UIColor *themeColor;

+ (id)shared;

- (UIFont *)boldFontWithSize:(NSInteger)size;
- (UIFont *)lightFontWithSize:(NSInteger)size;
- (UIFont *)regularFontWithSize:(NSInteger)size;
- (UIFont *)semiBoldFontWithSize:(NSInteger)size;

+ (void)registerFontFromResource:(NSString *)fontFilePath;
+ (void)registerSourceSansProFonts;

@end
