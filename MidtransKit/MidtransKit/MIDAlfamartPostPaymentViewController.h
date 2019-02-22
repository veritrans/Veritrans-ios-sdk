//
//  MIDAlfamartPostPaymentViewController.h
//  MidtransKit
//
//  Created by Arie.Prasetiyo on 20/02/19.
//  Copyright © 2019 Midtrans. All rights reserved.
//

#import "MidtransUIPaymentController.h"

NS_ASSUME_NONNULL_BEGIN
@class MidtransTransactionResult,MidtransTransactionTokenResponse;
@interface MIDAlfamartPostPaymentViewController : MidtransUIPaymentController
@property (nonatomic,strong) MidtransTransactionResult *transactionResult;
@property (nonatomic,strong) MidtransTransactionTokenResponse *token;
@end

NS_ASSUME_NONNULL_END
