//
//  VTViewController.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 7/1/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTViewController.h"
#import "VTClassHelper.h"
#import "VTThemeManager.h"
#import "VTBackBarButtonItem.h"

@interface VTViewController ()

@end

@implementation VTViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem = [[VTBackBarButtonItem alloc] initWithTitle:UILocalizedString(@"Back", nil)];
}

@end
