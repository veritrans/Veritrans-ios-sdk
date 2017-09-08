//
//  VTDirectDebitController.m
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 6/16/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MidtransPaymentWebController.h"
#import "MidtransHelper.h"
#import "MidtransConstant.h"

@interface MidtransPaymentWebController () <UIWebViewDelegate, UIAlertViewDelegate>
@property (nonatomic) UIWebView *webView;
@property (nonatomic) NSString *paymentIdentifier;
@property (nonatomic, readwrite) MidtransTransactionResult *result;
@property (nonatomic) MidtransPaymentRequestV2Merchant *merchant;
@end

@implementation MidtransPaymentWebController

- (instancetype)initWithMerchant:(MidtransPaymentRequestV2Merchant *)merchant result:(MidtransTransactionResult *)result identifier:(NSString *)identifier {
    if (self = [super init]) {
        self.result = result;
        self.paymentIdentifier = identifier;
        self.merchant = merchant;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self.paymentIdentifier isEqualToString:MIDTRANS_PAYMENT_BRI_EPAY]) {
        self.title = @"BRI E-Pay";
    }
    else if ([self.paymentIdentifier isEqualToString:MIDTRANS_PAYMENT_BCA_KLIKPAY]) {
        self.title = @"BCA KlikPay";
    }
    else if ([self.paymentIdentifier isEqualToString:MIDTRANS_PAYMENT_MANDIRI_ECASH]) {
        self.title = @"LINE Pay e-cash / mandiri e-cash";
    }
    else if ([self.paymentIdentifier isEqualToString:MIDTRANS_PAYMENT_CIMB_CLICKS]) {
        self.title = @"CIMB Clicks";
    }
    
    self.webView = [UIWebView new];
    self.webView.translatesAutoresizingMaskIntoConstraints = NO;
    self.webView.scalesPageToFit = YES;
    self.webView.delegate = self;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(closePressed:)];
    
    [self.view addSubview:self.webView];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:0 views:@{@"view":self.webView}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:0 views:@{@"view":self.webView}]];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.result.redirectURL]];
}

- (void)closePressed:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Confirm Navigation", nil)
                                                    message:NSLocalizedString(@"Are you sure want to leave this page?", nil)
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"NO", nil)
                                          otherButtonTitles:NSLocalizedString(@"YES", nil), nil];
    [alert show];
}

#pragma mark - UIWebViewDelegate

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    if ([self.delegate respondsToSelector:@selector(webPaymentController:transactionError:)]) {
        [self.delegate webPaymentController:self transactionError:error];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSString *requestURL = webView.request.URL.absoluteString;
    
    if (([self.paymentIdentifier isEqualToString:MIDTRANS_PAYMENT_CIMB_CLICKS] && [requestURL containsString:@"cimb-clicks/response"]) ||
        ([self.paymentIdentifier isEqualToString:MIDTRANS_PAYMENT_BCA_KLIKPAY] && [requestURL containsString:@"id="]) ||
        ([self.paymentIdentifier isEqualToString:MIDTRANS_PAYMENT_MANDIRI_ECASH] && [requestURL containsString:@"notify"]) ||
        ([self.paymentIdentifier isEqualToString:MIDTRANS_PAYMENT_BRI_EPAY] && [requestURL containsString:@"briPayment"])) {
        
        if ([self.delegate respondsToSelector:@selector(webPaymentController_transactionPending:)]) {
            [self.delegate webPaymentController_transactionPending:self];
        }
    }
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (NSError *)transactionError {
    NSError *error = [[NSError alloc] initWithDomain:MIDTRANS_ERROR_DOMAIN code:MIDTRANS_ERROR_CODE_CANCELED_WEBPAYMENT userInfo:@{NSLocalizedDescriptionKey:NSLocalizedString(@"Transaction canceled by user", nil)}];
    return error;
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        if ([self.delegate respondsToSelector:@selector(webPaymentController_transactionPending:)]) {
            [self.delegate webPaymentController_transactionPending:self];
        }
    }
}

@end
