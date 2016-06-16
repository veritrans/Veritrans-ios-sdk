//
//  VTDirectDebitController.m
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 6/16/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTDirectDebitController.h"
#import "VTHelper.h"

@interface VTDirectDebitController () <UIWebViewDelegate>
@property (nonatomic) UIWebView *webView;
@property (nonatomic) NSURL *redirectURL;
@property (nonatomic, copy) void (^_Nullable callback)(NSError *_Nullable error);
@end

@implementation VTDirectDebitController

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
    NSInteger canceledDirectDebitErrorCode = -31;
    NSError *error = [[NSError alloc] initWithDomain:ErrorDomain code:canceledDirectDebitErrorCode userInfo:@{NSLocalizedDescriptionKey:@"Direct debit transaction canceled by user"}];
    if (self.callback) self.callback(error);
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showPageWithCallback:(void(^_Nullable)(NSError *_Nullable error))callback {
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:self];
    [[UIApplication rootViewController] presentViewController:nvc animated:YES completion:nil];
    self.callback = callback;
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    if (self.callback) self.callback(error);
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    NSURL *reqURL = webView.request.URL;
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    for (NSString *param in [reqURL.query componentsSeparatedByString:@"&"]) {
        NSArray *elts = [param componentsSeparatedByString:@"="];
        if([elts count] < 2) continue;
        [params setObject:[elts lastObject] forKey:[elts firstObject]];
    }
    
    if (params && params[@"id"]) {
        if (self.callback) self.callback(nil);
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
@end
