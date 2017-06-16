//
//  VT3DSController.h
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 2/17/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MidtransTransactionResult.h"

@interface Midtrans3DSController : UIViewController
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, readonly) NSURL *secureURL;
@property (nonatomic, readonly) NSString *token;
@property (nonatomic,strong) NSString *titleOveride;
- (instancetype)initWithToken:(NSString *)token
                    secureURL:(NSURL *)secureURL;

- (void)showWithCompletion:(void(^)(NSError *error))completion;

@end
