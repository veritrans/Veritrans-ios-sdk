//
//  VTPaymentGeneralViewController.m
//  MidtransKit
//
//  Created by Arie on 6/18/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTPaymentGeneralViewController.h"
#import "VTPaymentGeneralView.h"
#import "VTClassHelper.h"
#import "UIViewController+HeaderSubtitle.h"
#import "VTStringHelper.h"
#import <MidtransCoreKit/MidtransCoreKit.h>

@interface VTPaymentGeneralViewController () <VTPaymentWebControllerDelegate>
@property (strong, nonatomic) IBOutlet VTPaymentGeneralView *view;

@end

@implementation VTPaymentGeneralViewController
@dynamic view;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setHeaderWithTitle:self.paymentMethod.title subTitle:@"Payment Instructions"];
    
    
    NSString *guidePath = [VTBundle pathForResource:self.paymentMethod.internalBaseClassIdentifier ofType:@"plist"];
    NSArray *instructions = [VTClassHelper instructionsFromFilePath:guidePath];
    
    self.view.guideView.instructions = instructions;
    self.view.totalAmountLabel.text = self.token.transactionDetails.grossAmount.formattedCurrencyNumber;
    self.view.orderIdLabel.text = self.token.transactionDetails.orderId;
}

- (IBAction)confirmPaymentPressed:(UIButton *)sender {
    [self showLoadingHud];
    
    id<VTPaymentDetails>paymentDetails;
    
    if ([self.paymentMethod.internalBaseClassIdentifier isEqualToString:VT_PAYMENT_BCA_KLIKPAY]) {
        paymentDetails = [[VTPaymentBCAKlikpay alloc] initWithToken:self.token];
    }
    else if ([self.paymentMethod.internalBaseClassIdentifier isEqualToString:VT_PAYMENT_MANDIRI_ECASH]) {
        paymentDetails = [[VTPaymentMandiriECash alloc] initWithToken:self.token];
    }
    else if ([self.paymentMethod.internalBaseClassIdentifier isEqualToString:VT_PAYMENT_BRI_EPAY]) {
        paymentDetails = [[VTPaymentEpayBRI alloc] initWithToken:self.token];
    }
    else if ([self.paymentMethod.internalBaseClassIdentifier isEqualToString:VT_PAYMENT_CIMB_CLICKS]) {
        paymentDetails = [[VTPaymentCIMBClicks alloc] initWithToken:self.token];
    }
    else if ([self.paymentMethod.internalBaseClassIdentifier isEqualToString:VT_PAYMENT_XL_TUNAI]) {
        paymentDetails = [[VTPaymentXLTunai alloc] initWithToken:self.token];
    }
    
    VTTransaction *transaction = [[VTTransaction alloc] initWithPaymentDetails:paymentDetails];
    [[VTMerchantClient sharedClient] performTransaction:transaction completion:^(VTTransactionResult *result, NSError *error) {
        [self hideLoadingHud];
        
        if (error) {
            [self handleTransactionError:error];
        }
        else {
            if (result.redirectURL) {
                VTPaymentWebController *vc = [[VTPaymentWebController alloc] initWithTransactionResult:result
                                                                                     paymentIdentifier:self.paymentMethod.internalBaseClassIdentifier];
                vc.delegate = self;
                [self.navigationController pushViewController:vc animated:YES];
            }
            else {
                [self handleTransactionSuccess:result];
            }
        }
    }];
}

#pragma mark - VTPaymentWebControllerDelegate

- (void)webPaymentController_transactionFinished:(VTPaymentWebController *)webPaymentController {    
    [super handleTransactionSuccess:webPaymentController.result];
}

- (void)webPaymentController_transactionPending:(VTPaymentWebController *)webPaymentController {
    [self handleTransactionPending:webPaymentController.result];
}

- (void)webPaymentController:(VTPaymentWebController *)webPaymentController transactionError:(NSError *)error {
    [self handleTransactionError:error];
}

@end
