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

+ (UIColor *)mdDarkColor {
    return [UIColor colorWithRed:3/255. green:3/255. blue:3/255. alpha:1];
}
+ (UIColor *)mdThemeColor {
    return [NSKeyedUnarchiver unarchiveObjectWithData:defaults_object(@"md_color")];
}

- (BOOL)isEqualToColor:(UIColor *)otherColor {
    CGFloat r1, g1, b1, a1, r2, g2, b2, a2;
    [self getRed:&r1 green:&g1 blue:&b1 alpha:&a1];
    [otherColor getRed:&r2 green:&g2 blue:&b2 alpha:&a2];
    return
    fabs(r1 - r2) <= 0.01 &&
    fabs(g1 - g2) <= 0.01 &&
    fabs(b1 - b2) <= 0.01 &&
    fabs(a1 - a2) <= 0.01;
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
