//
//  VTKlikbcaSuccessController.h
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 8/16/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTPaymentController.h"
#import "VTPaymentStatusViewModel.h"

@interface VTKlikbcaSuccessController : VTPaymentController
- (instancetype)initWithToken:(MidtransTransactionTokenResponse *)token
            paymentMethodName:(MidtransPaymentListModel *)paymentMethod
                    viewModel:(VTPaymentStatusViewModel *)viewModel;
@end
