//
//  VT3DSController.m
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 2/17/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "Midtrans3DSController.h"
#import "MidtransHelper.h"
#import "MidtransConstant.h"
#import "MidtransMerchantClient.h"
#import "MidtransTransaction.h"
@interface Midtrans3DSController() <WKNavigationDelegate>
@property (nonatomic) NSURL *secureURL;
@property (nonatomic) NSString *token;
@property (nonatomic) UIViewController *rootViewController;
@property (nonatomic, copy) void (^completion)(NSError *error);
@end

@implementation Midtrans3DSController

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
    
    self.title =self.titleOveride.length?self.titleOveride:NSLocalizedString(@"3D Secure", nil);
    self.title = @"Credit Card";
    
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
    [self.view addSubview:self.webView];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:0 views:@{@"view":self.webView}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:0 views:@{@"view":self.webView}]];
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.secureURL]];
}

- (void)dealloc {
    
}

- (void)showWithCompletion:(void(^)(NSError *error))completion {
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:self];
    nvc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.rootViewController presentViewController:nvc animated:YES completion:nil];
    self.completion = completion;
}

- (void)scaleTo3DSSize {
    //    400x800 is the standard 3ds page size
    CGFloat factor = CGRectGetWidth(self.webView.frame) / 400.;
    NSString *jsCommand = [NSString stringWithFormat:@"document.body.style.zoom = %f;", factor];
    [self.webView evaluateJavaScript:jsCommand completionHandler:nil];
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self scaleTo3DSSize];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.completion) self.completion(nil);
    }];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    [self scaleTo3DSSize];
    //filter request
    NSURL *request = webView.URL;
    ////this is for rba
    if (request.pathComponents.count >3 && [request.pathComponents[4] isEqualToString:@"callback"] ) {
        
        [[MidtransMerchantClient shared] performCheckStatusRBA:self.transcationData completion:^(MidtransTransactionResult * _Nullable result, NSError * _Nullable error) {
            if (error) {
                if ([self.delegate respondsToSelector:@selector(rbaDidGetError:)]) {
                    [self dismissViewControllerAnimated:YES completion:^{
                        [self.delegate rbaDidGetError:error];
                    }];
                }
            }
            else {
                if ([self.delegate respondsToSelector:@selector(rbaDidGetTransactionStatus:)]) {
                    [self dismissViewControllerAnimated:YES completion:^{
                        [self.delegate rbaDidGetTransactionStatus:result];
                    }];
                }
            }
        }];
    }
    if (request.pathComponents.count > 3 && [request.pathComponents[3] isEqualToString:@"callback"]) {
        
        [self dismissViewControllerAnimated:YES completion:^{
            if (self.completion) self.completion(nil);
        }];
    }
}

@end
