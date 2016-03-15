//
//  VTAlertBackgroundView.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 3/14/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTAlertBackgroundView.h"
#import "VTClassHelper.h"

@implementation VTAlertBackgroundView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.backgroundColor = [UIColor clearColor];
    
    UIImage *background = [UIImage imageNamed:@"alertBackground" inBundle:VTBundle compatibleWithTraitCollection:nil];
    UIImageView *backgroundView = [UIImageView new];
    backgroundView.backgroundColor = [UIColor clearColor];
    backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    backgroundView.image = [background stretchableImageWithLeftCapWidth:20 topCapHeight:20];
    
    [self insertSubview:backgroundView atIndex:0];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[bg]|" options:0 metrics:0 views:@{@"bg":backgroundView}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[bg]|" options:0 metrics:0 views:@{@"bg":backgroundView}]];
    
}

@end
