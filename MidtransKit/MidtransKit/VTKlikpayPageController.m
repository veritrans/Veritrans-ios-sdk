//
//  VTKlikpayPageController.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 6/13/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTKlikpayPageController.h"

@interface VTKlikpayPageController () <UIWebViewDelegate>
@property (nonatomic) UIWebView *webView;
@property (nonatomic) NSURL *redirectURL;
@end

@implementation VTKlikpayPageController

- (instancetype _Nonnull)initWithRedirectURL:(NSURL * _Nonnull)redirectURL {
    if (self = [super init]) {
        self.redirectURL = redirectURL;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(closePressed:)];
    self.navigationItem.leftBarButtonItem = closeButton;
    self.title = @"BCA KlikPay";
    
    self.webView = [UIWebView new];
    self.webView.translatesAutoresizingMaskIntoConstraints = NO;
    self.webView.scalesPageToFit = YES;
    self.webView.delegate = self;
    
    [self.view addSubview:self.webView];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:0 views:@{@"view":self.webView}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:0 views:@{@"view":self.webView}]];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:_redirectURL]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)closePressed:(id)sender {

    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

}
@end
