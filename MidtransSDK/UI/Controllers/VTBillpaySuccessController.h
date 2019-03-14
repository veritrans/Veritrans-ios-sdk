//
//  VTBillpaySuccessController.h
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 5/30/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MidtransUIPaymentController.h"

@interface VTBillpaySuccessController : MidtransUIPaymentController
- (instancetype)initWithPaymentMethod:(MIDPaymentDetail *)paymentMethod result:(MIDMandiriBankTransferResult *)result;
@end
