//
//  VTPaymentViewController.h
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 2/25/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MidtransCoreKit/MidtransCoreKit.h>

#import "VTFontSource.h"

@class VTPaymentViewController;

@protocol VTPaymentViewControllerDelegate;

@protocol VTPaymentViewControllerDelegate <UINavigationControllerDelegate>
- (void)paymentViewController:(VTPaymentViewController *)viewController paymentPending:(MidtransTransactionResult *)result;
- (void)paymentViewController:(VTPaymentViewController *)viewController paymentSuccess:(MidtransTransactionResult *)result;
- (void)paymentViewController:(VTPaymentViewController *)viewController paymentFailed:(NSError *)error;
@end

@interface VTPaymentViewController : UINavigationController

- (instancetype)initWithToken:(MidtransTransactionTokenResponse *)token;

@property (nonatomic, weak) id<VTPaymentViewControllerDelegate> delegate;

@end
