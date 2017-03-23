//
//  MDUtils.h
//  MidtransDemo
//
//  Created by Nanang Rafsanjani on 3/23/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MDUtils : NSObject

@end

@interface UIColor (Midtrans)
+ (UIColor *)mdDarkColor;
+ (UIColor *)mdBlueColor;
@end

@interface UIFont (Midtrans)
+ (UIFont *)bariolRegularWithSize:(CGFloat)size;
+ (UIFont *)ssProLightWithSize:(CGFloat)size;
@end
