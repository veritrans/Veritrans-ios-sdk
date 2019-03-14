//
//  VTKlikbcaSuccessController.h
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 8/16/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MidtransUIPaymentController.h"

@interface VTKlikbcaSuccessController : MidtransUIPaymentController
- (instancetype)initWithPaymentMethod:(MIDPaymentDetail *)paymentMethod result:(MIDKlikbcaResult *)result;
@end
