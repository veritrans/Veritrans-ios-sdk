//
//  VTDirectDebitController.h
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 6/16/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTTransactionResult.h"

@protocol MTPaymentWebControllerDelegate;

@interface MTPaymentWebController : UIViewController

@property (nonatomic, readonly, nonnull) MTTransactionResult *result;
@property (nonatomic, assign, nullable) id<MTPaymentWebControllerDelegate>delegate;

- (instancetype _Nonnull)initWithTransactionResult:(MTTransactionResult * _Nonnull)result paymentIdentifier:(NSString *_Nonnull)paymentIdentifier;

@end


@protocol MTPaymentWebControllerDelegate <NSObject>

- (void)webPaymentController_transactionFinished:(MTPaymentWebController *_Nonnull)webPaymentController;
- (void)webPaymentController_transactionPending:(MTPaymentWebController *_Nonnull)webPaymentController;
- (void)webPaymentController:(MTPaymentWebController *_Nonnull)webPaymentController transactionError:(NSError *_Nonnull)error;

@end
