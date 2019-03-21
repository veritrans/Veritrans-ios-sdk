//
//  MIDAlfamartPostPaymentViewController.h
//  MidtransKit
//
//  Created by Arie.Prasetiyo on 20/02/19.
//  Copyright © 2019 Midtrans. All rights reserved.
//

#import "MidtransUIPaymentController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MIDAlfamartPostPaymentViewController : MidtransUIPaymentController

- (instancetype)initWithResult:(MIDCStoreResult *)result paymentMethod:(MIDPaymentDetail *)paymentMethod;

@end

NS_ASSUME_NONNULL_END
