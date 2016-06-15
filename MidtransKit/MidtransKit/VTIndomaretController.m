//
//  VTIndomaretController.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 6/13/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTIndomaretController.h"
#import "VTIndomaretGuideController.h"
#import "VTIndomaretSuccessController.h"

#import "VTTextField.h"
#import "VTKeyboardAccessoryView.h"
#import "VTHudView.h"
#import "VTButton.h"
#import "VTClassHelper.h"
#import "VTPaymentStatusViewModel.h"

#import <MidtransCoreKit/MidtransCoreKit.h>

@interface VTIndomaretController ()
@property (strong, nonatomic) IBOutlet UILabel *amountLabel;
@property (strong, nonatomic) IBOutlet UILabel *orderIdLabel;
@property (strong, nonatomic) IBOutlet VTTextField *emailTextField;
@property (nonatomic) VTKeyboardAccessoryView *keyboardAccessoryView;
@property (nonatomic) VTHudView *hudView;
@end

@implementation VTIndomaretController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:nil
                                                                            action:nil];
    
    self.title = @"Pay at Indomaret";
    
    _hudView = [[VTHudView alloc] init];
    
    _keyboardAccessoryView = [[VTKeyboardAccessoryView alloc] initWithFrame:CGRectZero fields:@[_emailTextField]];
    
    _emailTextField.text = self.customerDetails.email;
    
    self.amountLabel.text = [[NSObject indonesianCurrencyFormatter] stringFromNumber:self.transactionDetails.grossAmount];
    self.orderIdLabel.text = self.transactionDetails.orderId;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)helpPressed:(UIButton *)sender {
    VTIndomaretGuideController *vc = [[VTIndomaretGuideController alloc] initWithNibName:@"VTIndomaretGuideController" bundle:VTBundle];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)paymentPressed:(UIButton *)sender {
    [_hudView showOnView:self.navigationController.view];
    
    VTPaymentCStore *paymentDetails = [[VTPaymentCStore alloc] initWithStoreName:@"Indomaret" message:@""];
    
    self.customerDetails.email = _emailTextField.text;
    
    VTTransaction *transaction = [[VTTransaction alloc] initWithPaymentDetails:paymentDetails transactionDetails:self.transactionDetails customerDetails:self.customerDetails itemDetails:self.itemDetails];
    [[VTMerchantClient sharedClient] performTransaction:transaction completion:^(VTTransactionResult *result, NSError *error) {
        [_hudView hide];
        
        if (error) {
            [self handleTransactionError:error];
        } else {
            [self handleTransactionSuccess:result];
        }
    }];
}

- (void)handleTransactionSuccess:(VTTransactionResult *)result {
    VTPaymentStatusViewModel *vm = [[VTPaymentStatusViewModel alloc] initWithTransactionResult:result];
    VTIndomaretSuccessController *vc = [[VTIndomaretSuccessController alloc] initWithViewModel:vm];
    [self.navigationController pushViewController:vc animated:YES];
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
