//
//  VTBillpaySuccessController.h
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 5/30/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTPaymentController.h"
#import "VTVATransactionStatusViewModel.h"

@interface VTBillpaySuccessController : VTPaymentController
- (instancetype)initWithToken:(TransactionTokenResponse *)token
            paymentMethodName:(VTPaymentListModel *)paymentMethod
                  statusModel:(VTVATransactionStatusViewModel *)statusModel;
@end
