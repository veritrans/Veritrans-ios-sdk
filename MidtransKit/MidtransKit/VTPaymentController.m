//
//  VTPaymentController.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 5/11/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTPaymentController.h"
#import "VTClassHelper.h"
#import "VTHudView.h"
#import "VTPaymentGuideViewController.h"
@interface VTPaymentController ()
@property (nonatomic) VTHudView *hudView;
@end

@implementation VTPaymentController

- (instancetype)initWithCustomerDetails:(VTCustomerDetails *)customerDetails itemDetails:(NSArray <VTItemDetail*>*)itemDetails transactionDetails:(VTTransactionDetails *)transactionDetails {
    
    @try {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Midtrans" bundle:VTBundle];
        self = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    } @catch (NSException *exception) {
        self = [[[self class] alloc] initWithNibName:NSStringFromClass([self class]) bundle:VTBundle];
    }
    
    if (self) {
        self.customerDetails = customerDetails;
        self.itemDetails = itemDetails;
        self.transactionDetails = transactionDetails;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hudView = [[VTHudView alloc] init];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showLoadingHud {
    [self.hudView showOnView:self.navigationController.view];
}

- (void)hideLoadingHud {
    [self.hudView hide];
}

- (void)handleTransactionError:(NSError *)error {
    VTErrorStatusController *vc = [[VTErrorStatusController alloc] initWithError:error];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)handleTransactionSuccess:(VTTransactionResult *)result {
    VTPaymentStatusViewModel *vm = [[VTPaymentStatusViewModel alloc] initWithTransactionResult:result];
    VTSuccessStatusController *vc = [VTSuccessStatusController controllerWithSuccessViewModel:vm];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)showGuideViewControllerWithPaymentName:(NSString *)paymentName {
    VTPaymentGuideViewController *paymentGuideVC = [[VTPaymentGuideViewController alloc] initGuideWithPaymentMethodName:paymentName];
    [self.navigationController pushViewController:paymentGuideVC animated:YES];
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
