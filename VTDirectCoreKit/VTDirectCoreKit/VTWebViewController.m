//
//  VTWebViewController.m
//  VTDirectCoreKit
//
//  Created by Nanang Rafsanjani on 2/17/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTWebViewController.h"

@interface VTWebViewController() <UIWebViewDelegate>

@end

@implementation VTWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webView = [UIWebView new];
    self.webView.translatesAutoresizingMaskIntoConstraints = NO;
    self.webView.delegate = self;
    
    [self.view addSubview:self.webView];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:0 views:@{@"view":self.webView}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:0 views:@{@"view":self.webView}]];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.webUrl]];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    NSURLRequest *request = webView.request;
    if (request.URL.pathComponents.count > 3 &&
        [request.URL.pathComponents[3] isEqualToString:@"callback"]) {
        if ([self.webDelegate respondsToSelector:@selector(viewController_didFinishTransaction:)]) {
            [self.webDelegate viewController_didFinishTransaction:self];
        }
    }
}

@end
