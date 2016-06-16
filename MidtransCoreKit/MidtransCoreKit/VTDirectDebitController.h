//
//  VTDirectDebitController.h
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 6/16/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VTDirectDebitController : UIViewController
- (instancetype _Nonnull)initWithRedirectURL:(NSURL * _Nonnull)redirectURL;
- (void)showPageWithCallback:(void(^_Nullable)(NSError *_Nullable error))callback;
@end
