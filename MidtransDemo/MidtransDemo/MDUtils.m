//
//  MDUtils.m
//  MidtransDemo
//
//  Created by Nanang Rafsanjani on 3/23/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import "MDUtils.h"

@implementation MDUtils

@end

@implementation UIColor (Midtrans)

+ (UIColor *)colorWithHexString:(NSString *)hexstr {
    NSScanner *scanner;
    unsigned int rgbval;
    
    scanner = [NSScanner scannerWithString: hexstr];
    [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"#"]];
    [scanner scanHexInt: &rgbval];
    
    return [UIColor colorWithHexValue: rgbval];
}

+ (UIColor *)colorWithHexValue: (NSInteger) rgbValue {
    return [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0
                           green:((float)((rgbValue & 0xFF00) >> 8))/255.0
                            blue:((float)(rgbValue & 0xFF))/255.0
                           alpha:1.0];
    
}

+ (UIColor *)mdDarkColor {
    return [UIColor colorWithRed:3/255. green:3/255. blue:3/255. alpha:1];
}
+ (UIColor *)mdThemeColor {
    return [NSKeyedUnarchiver unarchiveObjectWithData:defaults_object(@"md_color")];
}
@end

@implementation UIFont (Midtrans)
+ (UIFont *)bariolRegularWithSize:(CGFloat)size {
    return [UIFont fontWithName:@"Bariol-Regular" size:size];
}
+ (UIFont *)ssProLightWithSize:(CGFloat)size {
    return [UIFont fontWithName:@"SourceSansPro-Light" size:size];
}
@end

@implementation NSString (Utils)

+ (NSString *)randomWithLength:(NSUInteger)length {
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity:length];
    for (int i=0; i<length; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform((int)[letters length])]];
    }
    return randomString;
}

@end
