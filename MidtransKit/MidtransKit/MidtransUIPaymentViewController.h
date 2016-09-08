//
//  VTPaymentViewController.h
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 2/25/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MidtransCoreKit/MidtransCoreKit.h>

#import "MidtransUIFontSource.h"

@class MidtransUIPaymentViewController;

@protocol MidtransUIPaymentViewControllerDelegate;

@protocol MidtransUIPaymentViewControllerDelegate <UINavigationControllerDelegate>
- (void)paymentViewController:(MidtransUIPaymentViewController *)viewController paymentPending:(MidtransTransactionResult *)result;
- (void)paymentViewController:(MidtransUIPaymentViewController *)viewController paymentSuccess:(MidtransTransactionResult *)result;
- (void)paymentViewController:(MidtransUIPaymentViewController *)viewController paymentFailed:(NSError *)error;
@end

@interface MidtransUIPaymentViewController : UINavigationController

- (instancetype)initWithToken:(MidtransTransactionTokenResponse *)token;

@property (nonatomic, weak) id<MidtransUIPaymentViewControllerDelegate> delegate;

@end
