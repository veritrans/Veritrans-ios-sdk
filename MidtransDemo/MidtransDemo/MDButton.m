//
//  MDButton.m
//  MidtransDemo
//
//  Created by Nanang Rafsanjani on 3/29/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import "MDButton.h"
#import "MDUtils.h"

@implementation MDButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    [self commonInit];
}
- (void)prepareForInterfaceBuilder {
    [super prepareForInterfaceBuilder];
    [self commonInit];
}

- (void)commonInit {
    self.imageEdgeInsets = UIEdgeInsetsMake(0, 300, 0, 0);
    
    self.backgroundColor = [UIColor mdThemeColor];
    defaults_observe_object(@"md_color", ^(NSNotification *note){
        self.backgroundColor = [UIColor mdThemeColor];
    });
}

@end
