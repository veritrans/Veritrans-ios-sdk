//
//  VTAlertBackgroundView.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 3/14/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTAlertBackgroundView.h"
#import "VTClassHelper.h"

@implementation VTAlertBackgroundView {
    UIImageView *_backgroundView;
}

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
    
    UIImage *background = [UIImage imageNamed:@"AlertBackground" inBundle:VTBundle compatibleWithTraitCollection:nil];
    background = [background stretchableImageWithLeftCapWidth:15 topCapHeight:15];
    
    _backgroundView = [UIImageView new];
    _backgroundView.backgroundColor = [UIColor clearColor];
    _backgroundView.contentMode = UIViewContentModeScaleToFill;
    _backgroundView.image = background;
    
    [self insertSubview:_backgroundView atIndex:0];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _backgroundView.frame = self.bounds;
}

@end
