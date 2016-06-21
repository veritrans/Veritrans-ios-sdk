//
//  VTPaymentDirectViewController.m
//  MidtransKit
//
//  Created by Arie on 6/18/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTPaymentDirectViewController.h"
#import "VTPaymentDirectView.h"
@interface VTPaymentDirectViewController ()
@property (strong, nonatomic) IBOutlet VTPaymentDirectView *view;

@end

@implementation VTPaymentDirectViewController
@dynamic view;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
