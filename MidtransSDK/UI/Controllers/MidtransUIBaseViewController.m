//
//  VTViewController.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 7/1/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MidtransUIBaseViewController.h"
#import "VTClassHelper.h"
#import "MidtransUIThemeManager.h"
#import "VTBackBarButtonItem.h"
#import "MIDVendorUI.h"

@interface MidtransUIBaseViewController ()

@end

@implementation MidtransUIBaseViewController

- (MIDPaymentInfo *)info {
    return [MIDVendorUI shared].info;
}

@end
