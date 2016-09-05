//
//  EpaymentViewController.m
//  VTDirectDemo
//
//  Created by Arie on 9/5/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "EpaymentViewController.h"
#import <MidtransCoreKit/MidtransCoreKit.h>
#import <MidtransCoreKit/VTPaymentListModel.h>
#import <MidtransCoreKit/PaymentRequestDataModels.h>
@interface EpaymentViewController () <VTPaymentWebControllerDelegate>

@end
@implementation NSNumber (formatter)

- (NSString *)formattedCurrencyNumber {
    NSNumberFormatter *nf = [NSNumberFormatter indonesianCurrencyFormatter];
    return [@"Rp " stringByAppendingString:[nf stringFromNumber:self]];
}

@end
@implementation EpaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =  self.paymentMethod.localPaymentIdentifier;
    self.transactionID.text = self.transactionToken.transactionDetails.orderId;
    self.transactionAmount.text = self.transactionToken.transactionDetails.grossAmount.formattedCurrencyNumber;
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)payNowButtonDidTapped:(id)sender {
    
    id<VTPaymentDetails>paymentDetails;
    
    if ([self.paymentMethod.internalBaseClassIdentifier isEqualToString:VT_PAYMENT_BCA_KLIKPAY]) {
        paymentDetails = [[VTPaymentBCAKlikpay alloc] initWithToken:self.transactionToken];
    }
    else if ([self.paymentMethod.internalBaseClassIdentifier isEqualToString:VT_PAYMENT_MANDIRI_ECASH]) {
        paymentDetails = [[VTPaymentMandiriECash alloc] initWithToken:self.transactionToken];
    }
    else if ([self.paymentMethod.internalBaseClassIdentifier isEqualToString:VT_PAYMENT_BRI_EPAY]) {
        paymentDetails = [[VTPaymentEpayBRI alloc] initWithToken:self.transactionToken];
    }
    else if ([self.paymentMethod.internalBaseClassIdentifier isEqualToString:VT_PAYMENT_CIMB_CLICKS]) {
        paymentDetails = [[VTPaymentCIMBClicks alloc] initWithToken:self.transactionToken];
    }
    else if ([self.paymentMethod.internalBaseClassIdentifier isEqualToString:VT_PAYMENT_XL_TUNAI]) {
        paymentDetails = [[VTPaymentXLTunai alloc] initWithToken:self.transactionToken];
    }
    
    VTTransaction *transaction = [[VTTransaction alloc] initWithPaymentDetails:paymentDetails];
    [[VTMerchantClient sharedClient] performTransaction:transaction completion:^(VTTransactionResult *result, NSError *error) {
        
        if (error) {
            
        }
        else {
            if (result.redirectURL) {
                VTPaymentWebController *vc = [[VTPaymentWebController alloc] initWithTransactionResult:result
                                                                                     paymentIdentifier:self.paymentMethod.internalBaseClassIdentifier];
                vc.delegate = self;
                [self.navigationController pushViewController:vc animated:YES];
            }
            else {
                
            }
        }
    }];
    
}

/**
 *  if there is payment opening the webview please using this as handler
 *
 *  @param webPaymentController webPaymentController description
 *  @param error                error description
 */
- (void)webPaymentController:(VTPaymentWebController *)webPaymentController transactionError:(NSError *)error {
}
@end
