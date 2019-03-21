//
//  VTXibView.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 3/6/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MidtransUIXibView.h"
#import "VTClassHelper.h"

@implementation MidtransUIXibView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        NSString *className = NSStringFromClass([self class]);
        _customView = [[VTBundle loadNibNamed:className owner:self options:nil] firstObject];
        self.backgroundColor = _customView.backgroundColor;
        _customView.backgroundColor = [UIColor clearColor];
        if (CGRectIsEmpty(frame)) {
            self.bounds = _customView.bounds;
        } else {
            _customView.frame = self.bounds;
        }
        
        [self addSubview:_customView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        NSString *className = NSStringFromClass([self class]);
        _customView = [[VTBundle loadNibNamed:className owner:self options:nil] firstObject];
        _customView.translatesAutoresizingMaskIntoConstraints = NO;
        self.backgroundColor = _customView.backgroundColor;
        _customView.backgroundColor = [UIColor clearColor];
        [self addSubview:_customView];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:0 views:@{@"view":_customView}]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:0 views:@{@"view":_customView}]];
    }
    return self;
}

@end
