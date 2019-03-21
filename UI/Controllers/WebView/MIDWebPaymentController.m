//
//  MIDWebPaymentController.m
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 14/02/19.
//  Copyright © 2019 Midtrans. All rights reserved.
//

#import "MIDWebPaymentController.h"

@interface MIDWebPaymentController () <UIWebViewDelegate, UIAlertViewDelegate>
@property (nonatomic) UIWebView *webView;
@property (nonatomic) NSString *paymentURL;
@end

@implementation MIDWebPaymentController

- (instancetype)initWithPaymentURL:(NSString *)paymentURL {
    if (self = [super init]) {
        self.paymentURL = paymentURL;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.dataSource.headerTitle;
    
    self.webView = [UIWebView new];
    self.webView.translatesAutoresizingMaskIntoConstraints = NO;
    self.webView.scalesPageToFit = YES;
    self.webView.delegate = self;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(closePressed:)];
    
    
    [self.view addSubview:self.webView];
    NSArray *constraints = @[[self.webView.topAnchor constraintEqualToAnchor:self.topLayoutGuide.bottomAnchor],
                             [self.webView.bottomAnchor constraintEqualToAnchor:self.bottomLayoutGuide.topAnchor],
                             [self.webView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
                             [self.webView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor]
                             ];
    [NSLayoutConstraint activateConstraints:constraints];

    NSString *urlBase = [NSString stringWithFormat:@"%@", self.paymentURL];
    NSMutableCharacterSet *sets = [NSMutableCharacterSet new];
    [sets formUnionWithCharacterSet:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [sets formUnionWithCharacterSet:[NSCharacterSet URLHostAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:[urlBase stringByAddingPercentEncodingWithAllowedCharacters:sets]];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)closePressed:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Confirm Navigation", nil)
                                                                   message:NSLocalizedString(@"Are you sure want to leave this page?", nil)
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"NO", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"YES", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([self.delegate respondsToSelector:@selector(webPaymentControllerDidPending:)]) {
            [self.delegate webPaymentControllerDidPending:self];
        }
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - UIWebViewDelegate

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    if ([self.delegate respondsToSelector:@selector(webPaymentController:didError:)]) {
        [self.delegate webPaymentController:self didError:error];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSString *requestURL = webView.request.URL.absoluteString;
    
    if ([requestURL containsString:self.dataSource.finishedSignText]) {
        if ([self.delegate respondsToSelector:@selector(webPaymentControllerDidPending:)]) {
            [self.delegate webPaymentControllerDidPending:self];
        }
    }
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (NSError *)transactionError {
    NSError *error = [[NSError alloc] initWithDomain:@"error.midtrans.com" code:0 userInfo:@{NSLocalizedDescriptionKey:NSLocalizedString(@"Transaction canceled by user", nil)}];
    return error;
}

- (BOOL)webView:(__unused UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType
{
    if (![request.URL.scheme isEqual:@"http"] &&
        ![request.URL.scheme isEqual:@"https"] &&
        ![request.URL.scheme isEqual:@"about:blank"]) {
        if ([[UIApplication sharedApplication]canOpenURL:request.URL]) {
            [[UIApplication sharedApplication]openURL:request.URL];
        }
        return NO;
    }
    
    return YES;
    
}
@end
