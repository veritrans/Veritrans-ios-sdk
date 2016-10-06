//
//  VTIndomaretSuccessController.h
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 6/13/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MidtransUIPaymentController.h"
#import "VTPaymentStatusViewModel.h"

@interface VTIndomaretSuccessController : MidtransUIPaymentController
- (instancetype)initWithToken:(MidtransTransactionTokenResponse *)token
            paymentMethodName:(MidtransPaymentListModel *)paymentMethod
                  statusModel:(VTPaymentStatusViewModel *)statusModel;
@end
