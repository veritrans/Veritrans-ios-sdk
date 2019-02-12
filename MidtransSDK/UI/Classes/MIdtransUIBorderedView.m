//
//  MIdtransUIBorderedView.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 2/29/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MIdtransUIBorderedView.h"

@implementation MIdtransUIBorderedView

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.contentMode = UIViewContentModeRedraw;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.contentMode = UIViewContentModeRedraw;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
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
