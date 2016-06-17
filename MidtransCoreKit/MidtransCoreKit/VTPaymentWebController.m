//
//  VTDirectDebitController.m
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 6/16/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTPaymentWebController.h"
#import "VTHelper.h"
#import "VTConstant.h"

@interface VTPaymentWebController () <UIWebViewDelegate>
@property (nonatomic) UIWebView *webView;
@property (nonatomic) NSURL *redirectURL;
@property (nonatomic) NSString *paymentType;
@property (nonatomic, copy) void (^_Nullable callback)(NSError *_Nullable error);
@end

@implementation VTPaymentWebController

- (instancetype _Nonnull)initWithRedirectURL:(NSURL * _Nonnull)redirectURL paymentType:(NSString *_Nonnull)paymentType {
    if (self = [super init]) {
        self.redirectURL = redirectURL;
        self.paymentType = paymentType;
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
    if (self.callback) self.callback([self transactionError]);
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
    
    NSURLRequest *request = webView.request;
    
    if ([_paymentType isEqualToString:VT_PAYMENT_BCA_KLIKPAY]) {
        NSDictionary *params = [self dictionaryFromQueryString:request.URL.query];
        if (params && params[@"id"]) {
            if (self.callback) self.callback(nil);
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    } else {
        NSString *requestBodyString = [[NSString alloc] initWithData:[request HTTPBody] encoding:NSUTF8StringEncoding];
        requestBodyString = [[requestBodyString stringByReplacingOccurrencesOfString:@"+"
                                                                          withString:@" "]
                             stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary *body = [self dictionaryFromQueryString:requestBodyString];
        
        if (body[@"response"]) {
            NSData *data = [body[@"response"] dataUsingEncoding:NSUTF8StringEncoding];
            id response = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            NSError *error;
            if ([response[@"transaction_status"] isEqualToString:VT_TRANSACTION_STATUS_DENY]) {
                error = [self transactionError];
            }
            
            if (self.callback) self.callback(error);
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

- (NSError *)transactionError {
    NSInteger canceledDirectDebitErrorCode = -31;
    NSError *error = [[NSError alloc] initWithDomain:VT_ERROR_DOMAIN code:canceledDirectDebitErrorCode userInfo:@{NSLocalizedDescriptionKey:NSLocalizedString(@"Transaction canceled by user", nil)}];
    return error;
}

- (NSDictionary *)dictionaryFromQueryString:(NSString *)queryString {
    NSArray *urlComponents = [queryString componentsSeparatedByString:@"&"];
    NSMutableDictionary *queryStringDictionary = [NSMutableDictionary new];
    for (NSString *keyValuePair in urlComponents) {
        NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
        NSString *key = [[pairComponents firstObject] stringByRemovingPercentEncoding];
        NSString *value = [[pairComponents lastObject] stringByRemovingPercentEncoding];
        [queryStringDictionary setObject:value forKey:key];
    }
    return queryStringDictionary;
}
@end
