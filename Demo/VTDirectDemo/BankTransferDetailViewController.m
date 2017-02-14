//
//  BankTransferDetailViewController.m
//  VTDirectDemo
//
//  Created by Vanbungkring on 2/14/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import "BankTransferDetailViewController.h"

@interface BankTransferDetailViewController ()

@end

@implementation BankTransferDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.transactionDetail.text = [NSString stringWithFormat:@"%@ %@",self.bankName,self.transactionData];
    // Do any additional setup after loading the view from its nib.
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
