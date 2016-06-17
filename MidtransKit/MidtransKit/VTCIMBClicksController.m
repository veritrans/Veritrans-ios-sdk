//
//  VTCIMBClicksController.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 6/13/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTCIMBClicksController.h"
#import "VTClassHelper.h"
#import "VTPaymentGuideController.h"
#import "UIViewController+HeaderSubtitle.h"
#import "VTCIMBClicksView.h"
#import "VTStringHelper.h"

#import <MidtransCoreKit/MidtransCoreKit.h>

@interface VTCIMBClicksController ()
@property (strong, nonatomic) IBOutlet VTCIMBClicksView *view;
@end

@implementation VTCIMBClicksController
@dynamic view;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setHeaderWithTitle:@"CIMB Clicks" subTitle:@"Payment Instructions"];
    
    self.view.guideTextView.attributedText = [VTStringHelper numberingTextWithLocalizedStringPath:VT_PAYMENT_CIMB_CLICKS objectAtIndex:0];
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
    
    VTPaymentCIMBClicks *paymentDetails = [[VTPaymentCIMBClicks alloc] initWithDescription:@"dummy_description"];
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
