//
//  MidtransUIPaymentListHeader.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 5/30/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MidtransUIPaymentListHeader.h"
#import "MidtransUIThemeManager.h"

@interface MidtransUIPaymentListHeader()

@end

@implementation MidtransUIPaymentListHeader

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[MidtransUIThemeManager shared] themeColor];
    }
    return self;
}

@end
