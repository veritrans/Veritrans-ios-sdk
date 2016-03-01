//
//  VTButton.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 3/1/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTButton.h"

@implementation VTButton

- (void)awakeFromNib {
    if (self.topLine) {
        UIView *bottomBorder = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1)];
        bottomBorder.backgroundColor = self.topLineColor;
        [self addSubview:bottomBorder];
    }
}

@end
