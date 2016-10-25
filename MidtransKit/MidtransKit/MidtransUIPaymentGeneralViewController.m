//
//  VTPaymentGeneralViewController.m
//  MidtransKit
//
//  Created by Arie on 6/18/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MidtransUIPaymentGeneralViewController.h"
#import "MidtransUIPaymentGeneralView.h"
#import "VTClassHelper.h"
#import "UIViewController+HeaderSubtitle.h"
#import "MidtransUIStringHelper.h"
#import <MidtransCoreKit/MidtransCoreKit.h>

@interface MidtransUIPaymentGeneralViewController () <MidtransPaymentWebControllerDelegate>
@property (strong, nonatomic) IBOutlet MidtransUIPaymentGeneralView *view;

@end

@implementation MidtransUIPaymentGeneralViewController
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
    
    id<MidtransPaymentDetails>paymentDetails;
    
    if ([self.paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_BCA_KLIKPAY]) {
        paymentDetails = [[MidtransPaymentBCAKlikpay alloc] init];
    }
    else if ([self.paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_MANDIRI_ECASH]) {
        paymentDetails = [[MidtransPaymentMandiriECash alloc] init];
    }
    else if ([self.paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_BRI_EPAY]) {
        paymentDetails = [[MidtransPaymentEpayBRI alloc] init];
    }
    else if ([self.paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_CIMB_CLICKS]) {
        paymentDetails = [[MidtransPaymentCIMBClicks alloc] init];
    }
    else if ([self.paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_XL_TUNAI]) {
        paymentDetails = [[MidtransPaymentXLTunai alloc] init];
    }
    
    MidtransTransaction *transaction = [[MidtransTransaction alloc] initWithPaymentDetails:paymentDetails token:self.token];
    
    [[MidtransMerchantClient shared] performTransaction:transaction completion:^(MidtransTransactionResult *result, NSError *error) {
        [self hideLoadingHud];
        
        if (error) {
            [self handleTransactionError:error];
        }
        else {
            if (result.redirectURL) {
                MidtransPaymentWebController *vc = [[MidtransPaymentWebController alloc] initWithTransactionResult:result
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

- (void)webPaymentController_transactionFinished:(MidtransPaymentWebController *)webPaymentController {
    [super handleTransactionSuccess:webPaymentController.result];
}

- (void)webPaymentController_transactionPending:(MidtransPaymentWebController *)webPaymentController {
    [self handleTransactionPending:webPaymentController.result];
}

- (void)webPaymentController:(MidtransPaymentWebController *)webPaymentController transactionError:(NSError *)error {
    [self handleTransactionError:error];
}

@end
