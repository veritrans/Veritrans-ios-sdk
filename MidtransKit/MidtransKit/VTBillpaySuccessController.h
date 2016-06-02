//
//  VTBillpaySuccessController.h
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 5/30/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VTClassHelper.h"
#import "VTVATransactionStatusViewModel.h"

@interface VTBillpaySuccessController : UIViewController
- (instancetype)initWithViewModel:(VTVATransactionStatusViewModel *)viewModel;
@end
