//
//  MDProfileViewController.m
//  MidtransDemo
//
//  Created by Vanbungkring on 5/5/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import "MDProfileViewController.h"
#import "MDCardListViewController.h"
@interface MDProfileViewController ()

@end

@implementation MDProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"My Account";
    
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)myCardButtonDidTapped:(id)sender {
    MDCardListViewController *cardListVC = [[MDCardListViewController alloc] initWithNibName:@"MDCardListViewController" bundle:nil];
    [self.navigationController pushViewController:cardListVC animated:YES];
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
