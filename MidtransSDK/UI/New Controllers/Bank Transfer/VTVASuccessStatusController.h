//
//  VTVASuccessStatusController.h
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 5/20/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MidtransUIPaymentController.h"

@interface VTVASuccessStatusController : MidtransUIPaymentController
- (instancetype)initWithPaymentMethod:(MIDPaymentDetail *)paymentMethod result:(MIDPaymentResult *)result;
@end
