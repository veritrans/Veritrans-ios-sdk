//
//  VTErrorStatusController.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 3/7/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTErrorStatusController.h"
#import "VTClassHelper.h"

@interface VTErrorStatusController ()
@property (nonatomic) NSError *error;
@end

@implementation VTErrorStatusController

- (instancetype)initWithError:(NSError *)error {
    UIStoryboard *storybaord = [UIStoryboard storyboardWithName:@"Midtrans" bundle:VTBundle];
    if (self = [storybaord instantiateViewControllerWithIdentifier:@"VTErrorStatusController"]) {
        self.error = error;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"Payment Failed",nil);
    [self.navigationItem setHidesBackButton:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)finishPressed:(UIButton *)sender {
    NSDictionary *userInfo = @{@"tr_error":_error};
    [[NSNotificationCenter defaultCenter] postNotificationName:TRANSACTION_FAILED object:nil userInfo:userInfo];
    
    [self dismissViewControllerAnimated:YES completion:nil];
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
