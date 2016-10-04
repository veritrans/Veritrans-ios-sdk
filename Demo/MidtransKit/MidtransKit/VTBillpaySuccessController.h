//
//  VTBillpaySuccessController.h
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 5/30/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MidtransUIPaymentController.h"
#import "VTVATransactionStatusViewModel.h"

@interface VTBillpaySuccessController : MidtransUIPaymentController
- (instancetype)initWithToken:(MidtransTransactionTokenResponse *)token
            paymentMethodName:(MidtransPaymentListModel *)paymentMethod
                  statusModel:(VTVATransactionStatusViewModel *)statusModel;
@end
