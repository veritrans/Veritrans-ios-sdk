//
//  PaymentCreditCardViewController.m
//  VTDirectDemo
//
//  Created by Arie on 8/31/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "PaymentCreditCardViewController.h"
#import <MBProgressHUD.h>
#import <MidtransCoreKit/MidtransCoreKit.h>
#import <MidtransCoreKit/MidtransPaymentListModel.h>
@interface PaymentCreditCardViewController ()

@end

@implementation PaymentCreditCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Credit Card";
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)payNowDidTapped:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    MidtransCreditCard *creditCard = [[MidtransCreditCard alloc] initWithNumber:self.cardNumberTextField.text
                                                                    expiryMonth:self.cardExpireMonthTextfield.text expiryYear:self.cardExpireYeartextField.text                                                                cvv:self.cvvTextField.text];
    NSError *error = nil;
    if ([creditCard isValidCreditCard:&error] == NO) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"ERROR"
                                  message:@"Card is not valid"
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }
    BOOL enable3Ds = [CC_CONFIG secure];
    MidtransTokenizeRequest *tokenRequest = [[MidtransTokenizeRequest alloc] initWithCreditCard:creditCard
                                                                                    grossAmount:self.transactionToken.transactionDetails.grossAmount
                                                                                         secure:enable3Ds];
    [[MidtransClient shared] generateToken:tokenRequest
                                completion:^(NSString * _Nullable token, NSError * _Nullable error) {
                                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                                    if (error) {
                                        // create an alert view with three buttons
                                        UIAlertView *alertView = [[UIAlertView alloc]
                                                                  initWithTitle:@"ERROR"
                                                                  message:error.description
                                                                  delegate:self
                                                                  cancelButtonTitle:@"OK"
                                                                  otherButtonTitles:nil];
                                        [alertView show];
                                        
                                    } else {
                                        [self payWithToken:token];
                                    }
                                }];
}
- (void)payWithToken:(NSString *)token {
    MidtransPaymentCreditCard *paymentDetail = [MidtransPaymentCreditCard paymentWithToken:token customer:self.transactionToken.customerDetails];
    
    MidtransTransaction *transaction = [[MidtransTransaction alloc] initWithPaymentDetails:paymentDetail token:self.transactionToken];
    
    [[MidtransMerchantClient shared] performTransaction:transaction completion:^(MidtransTransactionResult *result, NSError *error) {
        if (error) {
            // create an alert view with three buttons
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"ERROR"
                                      message:error.description
                                      delegate:self
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
            [alertView show];
        } else {
            // create an alert view with three buttons
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"SUCCESS"
                                      message:result.statusMessage
                                      delegate:self
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
            [alertView show];
            
        }
    }];
}
@end
