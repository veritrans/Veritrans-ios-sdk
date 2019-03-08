//
//  MID3DSController.m
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 04/03/19.
//  Copyright © 2019 Midtrans. All rights reserved.
//

#import "MID3DSController.h"
#import "MIDViewHelper.h"
#import "MIDConstants.h"

#import <MidtransCoreKit.h>

@interface MID3DSController ()<UIWebViewDelegate, UIAlertViewDelegate>
@property (nonatomic) NSURL *secureURL;
@end

@implementation MID3DSController

- (instancetype)initWithURL:(NSURL *)secureURL
{
    if (self = [super init]) {
        self.secureURL = secureURL;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(closePressed:)];
    self.navigationItem.leftBarButtonItem = closeButton;
    self.title =self.titleOveride.length?self.titleOveride:NSLocalizedString(@"3D Secure", nil);
    self.title = @"Credit Card";
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
    NSError *error = [[NSError alloc] initWithDomain:MIDTRANS_ERROR_DOMAIN code:MIDTRANS_ERROR_CODE_3DSECURE userInfo:@{NSLocalizedDescriptionKey:@"3D Secure transaction canceled by user"}];
    if ([self.delegate respondsToSelector:@selector(secureAuthenticationError:error:)]) {
        [self.delegate secureAuthenticationError:self error:error];
    }
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self scaleTo3DSSize];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    if ([self.delegate respondsToSelector:@selector(secureAuthenticationError:error:)]) {
        [self.delegate secureAuthenticationError:self error:error];
    }
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
    ////this is for rba
    if (request.URL.pathComponents.count >3 && [request.URL.pathComponents[4] isEqualToString:@"callback"] ) {
        if ([self.delegate respondsToSelector:@selector(secureAuthenticationRBASuccess:)]) {
            [self.delegate secureAuthenticationRBASuccess:self];
        }
    } else if (request.URL.pathComponents.count > 3 && [request.URL.pathComponents[3] isEqualToString:@"callback"]) {
        if ([self.delegate respondsToSelector:@selector(secureAuthenticationSuccess:)]) {
            [self.delegate secureAuthenticationSuccess:self];
        }
    }
}

@end
