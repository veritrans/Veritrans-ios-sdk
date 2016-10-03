//
//  VTDirectDebitController.h
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 6/16/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MidtransTransactionResult.h"

@protocol MidtransPaymentWebControllerDelegate;

@interface MidtransPaymentWebController : UIViewController

@property (nonatomic, readonly, nonnull) MidtransTransactionResult *result;
@property (nonatomic, assign, nullable) id<MidtransPaymentWebControllerDelegate>delegate;

- (instancetype _Nonnull)initWithTransactionResult:(MidtransTransactionResult * _Nonnull)result paymentIdentifier:(NSString *_Nonnull)paymentIdentifier;

@end


@protocol MidtransPaymentWebControllerDelegate <NSObject>

- (void)webPaymentController_transactionFinished:(MidtransPaymentWebController *_Nonnull)webPaymentController;
- (void)webPaymentController_transactionPending:(MidtransPaymentWebController *_Nonnull)webPaymentController;
- (void)webPaymentController:(MidtransPaymentWebController *_Nonnull)webPaymentController transactionError:(NSError *_Nonnull)error;

@end
