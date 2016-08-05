//
//  VTWebViewController.h
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 2/17/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VTWebViewControllerDelegate;

@interface VTWebViewController : UIViewController
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NSURL *webUrl;
@property (nonatomic, assign) id<VTWebViewControllerDelegate>webDelegate;
@end

@protocol VTWebViewControllerDelegate<NSObject>
- (void)viewController_didFinishTransaction:(VTWebViewController *)viewController;
@end
