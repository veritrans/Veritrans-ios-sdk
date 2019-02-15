//
//  VTPendingStatusController.h
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 8/29/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MidtransUIPaymentController.h"
#import <MidtransCoreKit/MidtransCoreKit.h>

@interface VTPendingStatusController : MidtransUIPaymentController
- (instancetype)initWithPaymentMethodName:(MIDPaymentDetail *)paymentMethod
                                   result:(MIDPaymentResult *)result;
@end
