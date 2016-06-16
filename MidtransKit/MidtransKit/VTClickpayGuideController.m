//
//  VTClickpayHelpController.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 3/1/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTClickpayGuideController.h"
#import "VTClassHelper.h"
#import "VTPaymentGuideController.h"
#import "UIViewController+HeaderSubtitle.m"

@interface VTClickpayGuideController ()
@property (strong, nonatomic) IBOutlet UIView *helpView;
@end

@implementation VTClickpayGuideController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setHeaderWithTitle:@"Mandiri Clickpay" subTitle:@"Payment Instructions"];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Midtrans" bundle:VTBundle];
    VTPaymentGuideController *vc = [sb instantiateViewControllerWithIdentifier:@"VTPaymentGuideController"];
    NSString *path = [VTBundle pathForResource:@"clickpayGuide" ofType:@"plist"];
    vc.guides = [NSArray arrayWithContentsOfFile:path];
    [self addSubViewController:vc toView:_helpView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)gotItPressed:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
