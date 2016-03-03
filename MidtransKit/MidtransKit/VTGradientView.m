//
//  VTGradientView.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 3/3/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTGradientView.h"

@implementation VTGradientView

- (id)init {
    if (self = [super init]) {
        self.contentMode = UIViewContentModeRedraw;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (self.firstColor && self.secondColor) {
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        NSArray *colors = @[(id)self.firstColor.CGColor, (id)self.secondColor.CGColor];
        CGFloat locations[] = {0.0, 1.0};
        CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)colors, locations);
        CGContextDrawLinearGradient(context, gradient, CGPointZero, CGPointMake(0, CGRectGetHeight(self.bounds)), 0);
        
        CGColorSpaceRelease(colorSpace);
        CGGradientRelease(gradient);
    }
}

@end
