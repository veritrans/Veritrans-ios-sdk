//
//  SNPPostPaymentVAViewController.h
//  MidtransKit
//
//  Created by Vanbungkring on 4/12/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import "MidtransUIPaymentController.h"
@class MidtransTransactionResult,MidtransTransaction,MidtransPaymentListModel;
@interface SNPPostPaymentVAViewController : MidtransUIPaymentController
@property (nonatomic,strong)MidtransTransaction *transactionDetail;
@property (nonatomic,strong)MidtransTransactionResult *transactionResult;
@end
