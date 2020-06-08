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
#import <WebKit/WebKit.h>

@interface MidtransPaymentWebController () <WKNavigationDelegate>
@property (nonatomic) WKWebView *webView;
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
    else if ([self.paymentIdentifier isEqualToString:MIDTRANS_PAYMENT_AKULAKU]) {
        self.title = @"Akulaku";
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
    
    //equal to pageToFit, also disable zooming automatically//
    NSString *source = [NSString stringWithFormat:@"var meta = document.createElement('meta');meta.name = 'viewport';meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';var head = document.getElementsByTagName('head')[0];head.appendChild(meta);"];
   
    WKUserScript *script = [[WKUserScript alloc]initWithSource:source injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:true];
    
    WKUserContentController *userContentController = [WKUserContentController new];
    WKWebViewConfiguration *config = [WKWebViewConfiguration new];
    
    config.userContentController = userContentController;
    [userContentController addUserScript:script];
    
    self.webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
    self.webView.translatesAutoresizingMaskIntoConstraints = NO;
    self.webView.navigationDelegate = self;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(closePressed:)];
    
    [self.view addSubview:self.webView];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:0 views:@{@"view":self.webView}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:0 views:@{@"view":self.webView}]];
    
    NSString *urlBase = [NSString stringWithFormat:@"%@",self.result.redirectURL];
    NSURL *url = [NSURL URLWithString:[urlBase stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];

    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)closePressed:(id)sender {
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:NSLocalizedString(@"Confirm Navigation", nil)
                                message:NSLocalizedString(@"Are you sure want to leave this page?", nil)
                                preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *noButton = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"NO", nil)
                               style:UIAlertActionStyleDefault
                               handler:nil];
    UIAlertAction *yesButton = [UIAlertAction
                                actionWithTitle:NSLocalizedString(@"YES", nil)
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
        if ([self.delegate respondsToSelector:@selector(webPaymentController_transactionPending:)]) {
            [self.delegate webPaymentController_transactionPending:self];
        }
    }];
    [alert addAction:noButton];
    [alert addAction:yesButton];
    [self presentViewController:alert animated:YES completion:nil];
}

- (NSError *)transactionError {
    NSError *error = [[NSError alloc] initWithDomain:MIDTRANS_ERROR_DOMAIN code:MIDTRANS_ERROR_CODE_CANCELED_WEBPAYMENT userInfo:@{NSLocalizedDescriptionKey:NSLocalizedString(@"Transaction canceled by user", nil)}];
    return error;
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    if ([self.delegate respondsToSelector:@selector(webPaymentController:transactionError:)]) {
        [self.delegate webPaymentController:self transactionError:error];
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSString *requestURL = webView.URL.absoluteString;
    
    if (([self.paymentIdentifier isEqualToString:MIDTRANS_PAYMENT_CIMB_CLICKS] && [requestURL containsString:@"cimb-clicks/response"]) ||
        ([self.paymentIdentifier isEqualToString:MIDTRANS_PAYMENT_BCA_KLIKPAY] && [requestURL containsString:@"id="]) ||
        ([self.paymentIdentifier isEqualToString:MIDTRANS_PAYMENT_MANDIRI_ECASH] && [requestURL containsString:@"notify"]) ||
        ([self.paymentIdentifier isEqualToString:MIDTRANS_PAYMENT_AKULAKU] && [requestURL containsString:@"akulaku/callback"]) ||
        ([self.paymentIdentifier isEqualToString:MIDTRANS_PAYMENT_BRI_EPAY] && [requestURL containsString:@"briPayment"])) {
        if ([self.delegate respondsToSelector:@selector(webPaymentController_transactionPending:)]) {
            [self.delegate webPaymentController_transactionPending:self];
        }
    }
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if (![webView.URL.scheme isEqual:@"http"] &&
        ![webView.URL.scheme isEqual:@"https"] &&
        ![webView.URL.scheme isEqual:@"about:blank"]) {
        if ([[UIApplication sharedApplication]canOpenURL:webView.URL]) {
            [[UIApplication sharedApplication]openURL:webView.URL];
        }
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}
@end
