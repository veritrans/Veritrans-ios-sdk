//
//  VT3DSController.h
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 2/17/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VT3DSControllerDelegate;

@interface VT3DSController : UIViewController
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NSURL *webUrl;
@property (nonatomic, assign) id<VT3DSControllerDelegate>webDelegate;
@end

@protocol VT3DSControllerDelegate<NSObject>
- (void)viewController_didFinishTransaction:(VT3DSController *)viewController;
@end
