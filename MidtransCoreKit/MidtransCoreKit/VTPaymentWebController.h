//
//  VTDirectDebitController.h
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 6/16/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VTPaymentWebController : UIViewController
- (instancetype _Nonnull)initWithRedirectURL:(NSURL * _Nonnull)redirectURL paymentType:(NSString *_Nonnull)paymentType;
- (void)showPageWithCallback:(void(^_Nullable)(NSError *_Nullable error))callback;
@end
