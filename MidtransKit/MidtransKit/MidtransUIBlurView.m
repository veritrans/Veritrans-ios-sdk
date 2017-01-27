//
//  MidtransUIBlurView.m
//  MidtransKit
//
//  Created by Vanbungkring on 1/26/17.
//  Copyright © 2017 Veritrans. All rights reserved.
//

#import "MidtransUIBlurView.h"

@implementation MidtransUIBlurView
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.80f];

}


@end
