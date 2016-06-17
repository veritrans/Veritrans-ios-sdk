//
//  VTSuccessStatusController.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 3/7/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTSuccessStatusController.h"
#import "VTClassHelper.h"

@interface VTSuccessStatusController ()
@property (weak, nonatomic) IBOutlet UIImageView *statusIconView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *transactionTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *paymentTypeLabel;

@property (nonatomic) VTPaymentStatusViewModel *successViewModel;
@end

@implementation VTSuccessStatusController

+ (instancetype)controllerWithSuccessViewModel:(VTPaymentStatusViewModel *)viewModel {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Midtrans" bundle:VTBundle];
    VTSuccessStatusController *vc = [storyboard instantiateViewControllerWithIdentifier:@"VTSuccessStatusController"];
    vc.successViewModel = viewModel;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Payment Successful",nil);
    [self.navigationItem setHidesBackButton:YES];
    
    _amountLabel.text = _successViewModel.totalAmount;
    _orderIdLabel.text = _successViewModel.orderId;
    _transactionTimeLabel.text = _successViewModel.transactionTime;
    _paymentTypeLabel.text = _successViewModel.paymentType;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)finishPressed:(UIButton *)sender {
    NSDictionary *userInfo = @{@"tr_result":_successViewModel.transactionResult};
    [[NSNotificationCenter defaultCenter] postNotificationName:TRANSACTION_SUCCESS object:nil userInfo:userInfo];
    
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
