//
//  MidtransPaymentMethodHeader.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 12/28/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MidtransPaymentMethodHeader.h"
#import "MidtransUIThemeManager.h"
#import "VTClassHelper.h"
@implementation MidtransPaymentMethodHeader

- (void)awakeFromNib {
    [super awakeFromNib];
    self.totalAmountLabel.text = [VTClassHelper getTranslationFromAppBundleForString:@"total.amount"];
<<<<<<< HEAD
=======
    self.backgroundColor = [[MidtransUIThemeManager shared] themeColor];
>>>>>>> 0a77979... change payment method header back to blue bg on top table
}
@end
