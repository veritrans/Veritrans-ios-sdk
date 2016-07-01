//
//  VTSuccessStatusController.h
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 3/7/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTViewController.h"
#import "VTPaymentStatusViewModel.h"

@interface VTSuccessStatusController : VTViewController
- (instancetype _Nonnull)initWithSuccessViewModel:(VTPaymentStatusViewModel *_Nonnull)viewModel;
@end
