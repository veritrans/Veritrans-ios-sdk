//
//  VTSingleGuideController.h
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 6/22/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MidtransUIPaymentController.h"
#import "MidtransKit.h"

@interface VTSingleGuideController : MidtransUIPaymentController
- (instancetype)initWithPaymentMethodModel:(MIDPaymentDetail *)model;
@end
