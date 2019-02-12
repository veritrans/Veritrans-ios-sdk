//
//  MidtransVAHeader.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 2/28/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import "MidtransVAHeader.h"
#import "MidtransUIThemeManager.h"

@interface MidtransVAHeader()
@end

@implementation MidtransVAHeader

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.tabSwitch.tintColor = [[MidtransUIThemeManager shared] themeColor];
}

@end
