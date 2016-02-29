//
//  VTBorderedView.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 2/29/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTBorderedView.h"

@implementation VTBorderedView

- (void)drawRect:(CGRect)rect {
    
    // Drawing code
    [_borderLineColor set];
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(currentContext, _borderLineWidth);
    
    if (_bottomLine) {
        CGContextMoveToPoint(currentContext,CGRectGetMinX(rect), CGRectGetMaxY(rect));
        CGContextAddLineToPoint(currentContext,CGRectGetMaxX(rect), CGRectGetMaxY(rect));
    }
    
    if (_topLine) {
        CGContextMoveToPoint(currentContext,CGRectGetMinX(rect), CGRectGetMinY(rect));
        CGContextAddLineToPoint(currentContext,CGRectGetMaxX(rect), CGRectGetMinY(rect));
    }

    CGContextStrokePath(currentContext);
}

@end
