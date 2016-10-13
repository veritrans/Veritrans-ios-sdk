//
//  VTNavigationViewController.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 10/13/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTNavigationViewController.h"
#import "VTFontManager.h"

@interface VTNavigationViewController ()

@end

@implementation VTNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBar.translucent = false;
    
    self.navigationBar.titleTextAttributes = @{NSFontAttributeName:[[VTFontManager shared] semiBoldFontWithSize:17], NSForegroundColorAttributeName:[UIColor colorWithRed:3/255. green:3/255. blue:3/255. alpha:1]};
    self.navigationBar.barTintColor = [UIColor whiteColor];
}

@end
