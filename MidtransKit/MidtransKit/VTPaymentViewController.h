//
//  VTPaymentViewController.h
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 2/25/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MidtransCoreKit/MidtransCoreKit.h>

@class VTPaymentViewController;

@protocol VTPaymentViewControllerDelegate;

@protocol VTPaymentViewControllerDelegate <UINavigationControllerDelegate>
- (void)paymentViewController:(VTPaymentViewController *)viewController paymentSuccess:(VTTransactionResult *)result;
- (void)paymentViewController:(VTPaymentViewController *)viewController paymentFailed:(NSError *)error;
@end

@interface VTPaymentViewController : UINavigationController

- (instancetype)initWithCustomerDetails:(VTCustomerDetails *)customerDetails
                            itemDetails:(NSArray <VTItemDetail *>*)itemDetails
                     transactionDetails:(VTTransactionDetails *)transactionDetails;

@property (nonatomic, weak) id<VTPaymentViewControllerDelegate>delegate;

@end
