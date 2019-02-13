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
@property (nonatomic,strong)MidtransTransaction *transactionDetail;
@property (nonatomic,strong)MidtransTransactionResult *transactionResult;
@end
