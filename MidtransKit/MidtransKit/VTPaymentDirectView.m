//
//  VTPaymentDirectView.m
//  MidtransKit
//
//  Created by Arie on 6/18/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTPaymentDirectView.h"

@implementation VTPaymentDirectView

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _vtInformationLabel.preferredMaxLayoutWidth = CGRectGetWidth(_vtInformationLabel.frame);
}
@end
