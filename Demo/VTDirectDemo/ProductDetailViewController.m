//
//  ProductDetailViewController.m
//  VTDirectDemo
//
//  Created by Vanbungkring on 3/15/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import "ProductDetailViewController.h"
#import "OrderReviewViewController.h"
@interface ProductDetailViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *productScrollView;

@end

@implementation ProductDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Product Detail";
    UIImage *backBtn = [UIImage imageNamed:@"back"];
    backBtn = [backBtn imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.backBarButtonItem.title=@"";
    self.navigationController.navigationBar.backIndicatorImage = backBtn;
    self.navigationController.navigationBar.backIndicatorTransitionMaskImage = backBtn;
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
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView ==self.productScrollView) {
        int page = scrollView.contentOffset.x / scrollView.frame.size.width;
        CGFloat width = scrollView.frame.size.width;
        [self.pager setCurrentPage:page];
    }

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
