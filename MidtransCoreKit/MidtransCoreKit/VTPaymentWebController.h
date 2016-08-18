//
//  VTDirectDebitController.h
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 6/16/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VTTransactionResult.h"

@protocol VTPaymentWebControllerDelegate;

@interface VTPaymentWebController : UIViewController

@property (nonatomic, readonly, nonnull) VTTransactionResult *result;
@property (nonatomic, assign, nullable) id<VTPaymentWebControllerDelegate>delegate;

- (instancetype _Nonnull)initWithTransactionResult:(VTTransactionResult * _Nonnull)result paymentIdentifier:(NSString *_Nonnull)paymentIdentifier;

@end


@protocol VTPaymentWebControllerDelegate <NSObject>

- (void)webPaymentController_transactionFinished:(VTPaymentWebController *_Nonnull)webPaymentController;
- (void)webPaymentController_transactionPending:(VTPaymentWebController *_Nonnull)webPaymentController;
- (void)webPaymentController:(VTPaymentWebController *_Nonnull)webPaymentController transactionError:(NSError *_Nonnull)error;

@end
