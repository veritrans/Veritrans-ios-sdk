//
//  ProductDetailViewController.m
//  VTDirectDemo
//
//  Created by Vanbungkring on 3/15/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import "ProductDetailViewController.h"
#import "OrderReviewViewController.h"
@interface ProductDetailViewController ()

@end

@implementation ProductDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)buyNowButtonDidTapped:(id)sender {
    OrderReviewViewController *orderVC = [[OrderReviewViewController alloc] initWithNibName:@"OrderReviewViewController" bundle:nil];
    [self.navigationController pushViewController:orderVC animated:YES];
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
