//
//  VTSuccessStatusController.h
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 3/7/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MidtransUIBaseViewController.h"
#import "VTPaymentStatusViewModel.h"

@interface VTSuccessStatusController : MidtransUIBaseViewController
- (instancetype _Nonnull)initWithSuccessViewModel:(VTPaymentStatusViewModel *_Nonnull)viewModel;
@end
