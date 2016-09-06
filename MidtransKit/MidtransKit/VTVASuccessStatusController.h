//
//  VTVASuccessStatusController.h
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 5/20/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTPaymentController.h"
#import "VTVATransactionStatusViewModel.h"

@interface VTVASuccessStatusController : VTPaymentController
- (instancetype)initWithToken:(MidtransTransactionTokenResponse *)token
            paymentMethodName:(MidtransPaymentListModel *)paymentMethod
                  statusModel:(VTVATransactionStatusViewModel *)statusModel;
@end
