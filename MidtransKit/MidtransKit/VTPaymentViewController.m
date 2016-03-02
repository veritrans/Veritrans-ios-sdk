//
//  VTPaymentViewController.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 2/25/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTPaymentViewController.h"
#import "VTClassHelper.h"
#import "VTCartController.h"

@interface VTPaymentViewController ()
@property (nonatomic) NSArray <VTItem *> *items;
@end

@implementation VTPaymentViewController

+ (instancetype)paymentWithUser:(VTUser *)user andItems:(NSArray<VTItem *> *)items {
    VTCartController *vc = [VTCartController cartWithUser:user andItems:items];
    VTPaymentViewController *nvc = [[VTPaymentViewController alloc] initWithRootViewController:vc];
    return nvc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:17], NSForegroundColorAttributeName:[UIColor colorWithRed:3/255. green:3/255. blue:3/255. alpha:1]};
    self.navigationBar.barTintColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
}

@end
