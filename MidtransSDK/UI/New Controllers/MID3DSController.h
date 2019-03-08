//
//  MID3DSController.h
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 04/03/19.
//  Copyright © 2019 Midtrans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MidtransSDK.h"

NS_ASSUME_NONNULL_BEGIN

@class MID3DSController;

@protocol MID3DSControllerDelegate<NSObject>
- (void)secureAuthenticationSuccess:(MID3DSController *)viewController;
- (void)secureAuthenticationRBASuccess:(MID3DSController *)viewController;
- (void)secureAuthenticationError:(MID3DSController *)viewController error:(NSError *)error ;
@end

@interface MID3DSController : UIViewController

@property (nonatomic) UIWebView *webView;
@property (nonatomic) NSString *titleOveride;
@property (nonatomic, weak) id<MID3DSControllerDelegate>delegate;

- (instancetype)initWithURL:(NSURL *)secureURL;

@end

NS_ASSUME_NONNULL_END
