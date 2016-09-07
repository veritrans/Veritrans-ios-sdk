//
//  VT3DSController.m
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 2/17/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MT3DSController.h"
#import "VTHelper.h"
#import "MTConstant.h"

@interface MT3DSController() <UIWebViewDelegate, UIAlertViewDelegate>
@property (nonatomic) NSURL *secureURL;
@property (nonatomic) NSString *token;
@property (nonatomic) UIViewController *rootViewController;
@property (nonatomic, copy) void (^completion)(NSError *error);
@end

@implementation MT3DSController

- (instancetype)initWithToken:(NSString *)token secureURL:(NSURL *)secureURL
{
    if (self = [super init]) {
        self.secureURL = secureURL;
        self.token = token;
    }
    return self;
}

- (UIViewController *)rootViewController {
    if (!_rootViewController) {
        _rootViewController = [UIApplication rootViewController];
    }
    return _rootViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(closePressed:)];
    self.navigationItem.leftBarButtonItem = closeButton;
    self.title = NSLocalizedString(@"3D Secure", nil);
    
    self.webView = [UIWebView new];
    self.webView.translatesAutoresizingMaskIntoConstraints = NO;
    self.webView.delegate = self;
    
    [self.view addSubview:self.webView];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:0 views:@{@"view":self.webView}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:0 views:@{@"view":self.webView}]];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.secureURL]];
}

- (void)dealloc {
    
}

- (void)closePressed:(id)sender {
    NSError *error = [[NSError alloc] initWithDomain:MT_ERROR_DOMAIN code:MT_ERROR_CODE_3DSECURE userInfo:@{NSLocalizedDescriptionKey:@"3D Secure transaction canceled by user"}];
    if (self.completion) self.completion(error);
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showWithCompletion:(void(^)(NSError *error))completion {
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:self];
    [self.rootViewController presentViewController:nvc animated:YES completion:nil];
    self.completion = completion;
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self scaleTo3DSSize];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.completion) self.completion(nil);
    }];
}

- (void)scaleTo3DSSize {
    //400x800 is the standard 3ds page size
    CGFloat factor = CGRectGetWidth(self.webView.frame) / 400.;
    NSString *jsCommand = [NSString stringWithFormat:@"document.body.style.zoom = %f;", factor];
    [self.webView stringByEvaluatingJavaScriptFromString:jsCommand];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    [self scaleTo3DSSize];
    
    //filter request
    NSURLRequest *request = webView.request;
    if (request.URL.pathComponents.count > 3 &&
        [request.URL.pathComponents[3] isEqualToString:@"callback"]) {
        
        [self dismissViewControllerAnimated:YES completion:^{
            if (self.completion) self.completion(nil);
        }];
    }
}

@end
