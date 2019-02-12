//
//  VTErrorStatusController.h
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 3/7/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MidtransUIPaymentController.h"

@interface VTErrorStatusController : MidtransUIBaseViewController
- (instancetype _Nonnull)initWithError:(NSError *_Nonnull)error;
@end
