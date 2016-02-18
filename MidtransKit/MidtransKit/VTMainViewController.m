//
//  VTMainViewController.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 2/18/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTMainViewController.h"
#import <MidtransCoreKit/MidtransCoreKit.h>
#import "Flurry.h"

@interface VTMainViewController ()

@end

@implementation VTMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    BOOL sandbox = [[[VTConfig sharedInstance] environment] isEqual:VTEnvironmentSandbox];
    if (sandbox) {
        [Flurry startSession:@"SD44GY5Y2YRSPP66QZXD"];
    } else {
        [Flurry startSession:@"X9FXW5PZQB3V5HDTRR7Z"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
