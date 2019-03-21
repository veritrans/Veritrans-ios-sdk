//
//  SNPPostPaymentGeneralViewController.h
//  MidtransKit
//
//  Created by Vanbungkring on 6/9/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import "MidtransUIPaymentController.h"
@class MidtransTransactionResult,MidtransTransaction,MidtransPaymentListModel;
@interface SNPPostPaymentGeneralViewController : MidtransUIPaymentController
- (instancetype)initWithPaymentResult:(MIDPaymentResult *)result paymentMethod:(MIDPaymentDetail *)paymentMethod;
@end
