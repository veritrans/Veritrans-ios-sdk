//
//  VTEpayBRIController.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 6/14/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTEpayBRIController.h"
#import "VTClassHelper.h"
#import "VTPaymentGuideController.h"
#import "UIViewController+HeaderSubtitle.h"
#import "VTEpayBRIView.h"
#import "VTStringHelper.h"

#import <MidtransCoreKit/MidtransCoreKit.h>

@interface VTEpayBRIController ()
@property (strong, nonatomic) IBOutlet VTEpayBRIView *view;
@end

@implementation VTEpayBRIController
@dynamic view;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setHeaderWithTitle:@"e-Pay BRI" subTitle:@"Payment Instructions"];
    
    self.view.guideTextView.attributedText = [VTStringHelper numberingTextWithLocalizedStringPath:VT_PAYMENT_BRI_EPAY objectAtIndex:0];
    NSNumberFormatter *formatter = [NSNumberFormatter indonesianCurrencyFormatter];
    self.view.totalAmountLabel.text = [formatter stringFromNumber:self.transactionDetails.grossAmount];
    self.view.orderIdLabel.text = self.transactionDetails.orderId;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)confirmPaymentPressed:(UIButton *)sender {
    [self showLoadingHud];
    
    VTPaymentEpayBRI *paymentDetails = [[VTPaymentEpayBRI alloc] init];
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

@end
