//
//  VTSingleGuideController.h
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 6/22/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTViewController.h"
#import <MidtransCoreKit/MidtransCoreKit.h>

@interface VTSingleGuideController : VTViewController
- (instancetype)initWithPaymentMethodModel:(MidtransPaymentListModel *)model;
@end
