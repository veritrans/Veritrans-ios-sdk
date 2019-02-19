//
//  SNPPostPaymentVAViewController.h
//  MidtransKit
//
//  Created by Vanbungkring on 4/12/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import "MidtransUIPaymentController.h"
#import "MidtransUINextStepButton.h"
@class MidtransTransactionResult,MidtransTransaction,MidtransPaymentListModel,MidtransPaymentRequestV2Response;
@interface SNPPostPaymentVAViewController : MidtransUIPaymentController

@property (weak, nonatomic) IBOutlet MidtransUINextStepButton *finishPaymentButton;

- (instancetype)initWithPaymentMethod:(MIDPaymentDetail *)paymentMethod
                        paymentResult:(MIDPaymentResult *)result;

@end
