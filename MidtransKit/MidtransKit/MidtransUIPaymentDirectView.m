//
//  VTPaymentDirectView.m
//  MidtransKit
//
//  Created by Arie on 6/18/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MidtransUIPaymentDirectView.h"

@implementation MidtransUIPaymentDirectView

- (void)layoutSubviews {
    [super layoutSubviews];
    _vtInformationLabel.preferredMaxLayoutWidth = CGRectGetWidth(_vtInformationLabel.frame);
}
@end
