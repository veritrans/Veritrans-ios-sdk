//
//  VTKlikbcaSuccessController.h
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 8/16/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MidtransUIPaymentController.h"
#import "VTPaymentStatusViewModel.h"

@interface VTKlikbcaSuccessController : MidtransUIPaymentController
- (instancetype)initWithToken:(MidtransTransactionTokenResponse *)token
            paymentMethodName:(MidtransPaymentListModel *)paymentMethod
                    viewModel:(VTPaymentStatusViewModel *)viewModel;
@end
