//
//  VTPaymentViewController.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 2/25/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTPaymentViewController.h"
#import "VTPaymentListController.h"
#import "VTClassHelper.h"

@interface VTPaymentViewController ()
@end

@implementation VTPaymentViewController

- (instancetype)initWithCustomerDetails:(VTCustomerDetails *)customerDetails itemDetails:(NSArray <VTItemDetail *>*)itemDetails transactionDetails:(VTTransactionDetails *)transactionDetails {
    VTPaymentListController *vc = [[VTPaymentListController alloc] initWithCustomerDetails:customerDetails itemDetails:itemDetails transactionDetails:transactionDetails];
    self = [[VTPaymentViewController alloc] initWithRootViewController:vc];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:17], NSForegroundColorAttributeName:[UIColor colorWithRed:3/255. green:3/255. blue:3/255. alpha:1]};
    self.navigationBar.barTintColor = [UIColor whiteColor];
    
    //register payment observer
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(transactionSuccess:) name:_TRANSACTION_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(transactionFailed:) name:_TRANSACTION_FAILED object:nil];
}

- (void)dealloc {
    //remove all observers
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)transactionSuccess:(NSNotification *)sender {
    if ([self.delegate respondsToSelector:@selector(paymentViewController:paymentSuccess:)]) {
        [self.delegate paymentViewController:self paymentSuccess:sender.userInfo[@"tr_result"]];
    }
}

- (void)transactionFailed:(NSNotification *)sender {
    if ([self.delegate respondsToSelector:@selector(paymentViewController:paymentFailed:)]) {
        [self.delegate paymentViewController:self paymentFailed:sender.userInfo[@"tr_error"]];
    }
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
}

@end
