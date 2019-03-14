//
//  VTIndomaretSuccessController.h
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 6/13/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MidtransUIPaymentController.h"

@interface VTIndomaretSuccessController : MidtransUIPaymentController
- (instancetype)initWithResult:(MIDCStoreResult *)result paymentMethod:(MIDPaymentDetail *)paymentMethod;
@end
