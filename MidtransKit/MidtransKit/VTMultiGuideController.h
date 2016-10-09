//
//  VTMultiGuideController.h
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 6/22/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MidtransUIBaseViewController.h"
#import <MidtransCoreKit/MidtransCoreKit.h>

@interface VTMultiGuideController : MidtransUIBaseViewController
- (instancetype)initWithPaymentMethodModel:(MidtransPaymentListModel *)model;
@end
