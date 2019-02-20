//
//  MIDAlfamartPostPaymentViewController.h
//  MidtransKit
//
//  Created by Arie.Prasetiyo on 20/02/19.
//  Copyright © 2019 Midtrans. All rights reserved.
//

#import "MidtransUIPaymentController.h"

NS_ASSUME_NONNULL_BEGIN
@class MidtransTransactionResult;
@interface MIDAlfamartPostPaymentViewController : MidtransUIPaymentController
@property (nonatomic,strong) MidtransTransactionResult *transactionResult;
@end

NS_ASSUME_NONNULL_END
