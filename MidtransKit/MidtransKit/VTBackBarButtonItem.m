//
//  VTBackBarButtonItem.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 7/1/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTBackBarButtonItem.h"
#import "VTClassHelper.h"
#import "MidtransUIThemeManager.h"

@implementation VTBackBarButtonItem

- (instancetype)initWithTitle:(NSString *)title {
    if (self = [super initWithTitle:title style:UIBarButtonItemStylePlain target:nil action:nil]) {
        NSDictionary *barButtonItemAttributes = @{NSFontAttributeName:[[MidtransUIThemeManager shared].themeFont fontRegularWithSize:17],
                                                  NSForegroundColorAttributeName:[MidtransUIThemeManager shared].themeColor};
        [self setTitleTextAttributes:barButtonItemAttributes forState:UIControlStateNormal];
    }
    return self;
}

@end
