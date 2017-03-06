//
//  VTMultiGuideController.h
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 6/22/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MidtransUIPaymentController.h"
#import <MidtransCoreKit/MidtransCoreKit.h>

@interface VTMultiGuideController : MidtransUIPaymentController
- (instancetype)initWithPaymentMethodModel:(MidtransPaymentListModel *)model;
@end
