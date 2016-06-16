//
//  VTKlikBCAViewController.m
//  MidtransKit
//
//  Created by Arie on 6/16/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTKlikBCAViewController.h"
#import "VTKlikBCAView.h"
#import "VTClassHelper.h"
#import "VTPaymentGuideController.h"
#import "UIViewController+HeaderSubtitle.h"
#import <MidtransCoreKit/MidtransCoreKit.h>
@interface VTKlikBCAViewController ()
@property (strong, nonatomic) IBOutlet VTKlikBCAView *view;

@end

@implementation VTKlikBCAViewController
@dynamic view;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Klik BCA",nil);
    NSNumberFormatter *formatter = [NSNumberFormatter indonesianCurrencyFormatter];
    self.view.totalAmountLabel.text = [formatter stringFromNumber:self.transactionDetails.grossAmount];
    self.view.orderIdLabel.text = self.transactionDetails.orderId;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)confirmPaymentButtonDidTapped:(id)sender {
    [self showLoadingHud];
    VTPaymentKlikBCA *paymentDetails = [[VTPaymentKlikBCA alloc] init];
    VTTransaction *transaction = [[VTTransaction alloc] initWithPaymentDetails:paymentDetails transactionDetails:self.transactionDetails customerDetails:self.customerDetails itemDetails:self.itemDetails];
    [[VTMerchantClient sharedClient] performTransaction:transaction completion:^(VTTransactionResult *result, NSError *error) {
        [self hideLoadingHud];
        if (error) {
            [self handleTransactionError:error];
        } else {
            [self handleTransactionSuccess:result];
        }
    }];
}
- (IBAction)guideButtonDidtapped:(id)sender {
    [self showGuideViewControllerWithPaymentName:@"Klik BCA"];
}

@end
