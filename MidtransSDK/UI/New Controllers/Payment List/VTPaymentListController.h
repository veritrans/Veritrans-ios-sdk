//
//  VTPaymentListController.h
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 2/22/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VTItemViewModel.h"
#import "MidtransUIPaymentController.h"
#import "MidtransSDK.h"

@interface VTPaymentListController : MidtransUIPaymentController
@property (nonatomic,strong)NSString *paymentMethodSelected;

- (instancetype)initWithPaymentInfo:(MIDPaymentInfo *)info;

@end
