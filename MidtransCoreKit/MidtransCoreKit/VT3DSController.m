//
//  VT3DSController.m
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 2/17/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VT3DSController.h"
#import "VTHudView.h"
#import "VTHelper.h"
#import "UIViewController+Modal.h"

@interface VT3DSController() <UIWebViewDelegate, UIAlertViewDelegate>
@property (nonatomic) VTHudView *hudView;
@property (nonatomic) NSURL *secureURL;
@property (nonatomic) NSString *token;
@property (nonatomic) UIViewController *rootViewController;
@property (nonatomic, copy) void (^completion)();

@end

@implementation VT3DSController

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
    
    _hudView = [[VTHudView alloc] init];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
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
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                    message:@"Are you sure?"
                                                   delegate:self
                                          cancelButtonTitle:@"No"
                                          otherButtonTitles:@"Yes", nil];
    [alert setTag:1];
    [alert show];
}

- (void)showWithCompletion:(void(^)())completion {
    self.modalSize = CGRectInset(self.rootViewController.view.frame, 20, 20).size;
    [self.rootViewController presentCustomViewController:self completion:nil];
    
    self.completion = completion;
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1 && buttonIndex == 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else if (alertView.tag == 2) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [_hudView showOnView:self.rootViewController.view];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error {
    [_hudView hide];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:error.localizedDescription
                                                   delegate:self
                                          cancelButtonTitle:@"Close"
                                          otherButtonTitles:nil];
    [alert setTag:2];
    [alert show];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [_hudView hide];
    
    //resize after its loaded
    CGSize contentSize = webView.scrollView.contentSize;
    CGFloat factor = self.modalSize.width / contentSize.width;
    NSString *jsCommand = [NSString stringWithFormat:@"document.body.style.zoom = %f;", factor];
    [self.webView stringByEvaluatingJavaScriptFromString:jsCommand];
    
    //filter request
    NSURLRequest *request = webView.request;
    if (request.URL.pathComponents.count > 3 &&
        [request.URL.pathComponents[3] isEqualToString:@"callback"]) {
        
        if (self.completion != nil) {
            self.completion();
        }
        
        [self dismissCustomViewController:nil];
    }
}

@end
