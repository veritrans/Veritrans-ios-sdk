//
//  VTBCAKlikpayController.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 6/13/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTBCAKlikpayController.h"
#import "VTClassHelper.h"
#import "VTPaymentGuideController.h"
#import "UIViewController+HeaderSubtitle.h"
#import "VTClassHelper.h"
#import "VTStringHelper.h"
#import "VTBCAKlikPayView.h"
#import <MidtransCoreKit/MidtransCoreKit.h>

@interface VTBCAKlikpayController ()
@property (strong, nonatomic) IBOutlet VTBCAKlikPayView *view;
@end

@implementation VTBCAKlikpayController
@dynamic view;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setHeaderWithTitle:@"BCA KlikPay" subTitle:NSLocalizedString(@"Payment Instructions",nil)];
    self.view.guideTextView.attributedText = [VTStringHelper numberingTextWithLocalizedStringPath:VT_PAYMENT_BCA_KLIKPAY objectAtIndex:0];
    NSNumberFormatter *formatter = [NSNumberFormatter indonesianCurrencyFormatter];
    self.view.totalAmountLabel.text = [formatter stringFromNumber:self.transactionDetails.grossAmount];
    self.view.orderIdLabel.text = self.transactionDetails.orderId;
}

- (IBAction)confirmPaymentPressed:(UIButton *)sender {
    [self showLoadingHud];
    
    VTPaymentBCAKlikpay *paymentDetails = [[VTPaymentBCAKlikpay alloc] initWithDescription:@"klikpay bca description"];
    
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
