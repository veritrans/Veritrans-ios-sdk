//
//  VTXLTunaiSuccessController.h
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 8/8/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MidtransUIPaymentController.h"
#import "VTPaymentStatusXLTunaiViewModel.h"

@interface VTXLTunaiSuccessController : MidtransUIPaymentController

- (instancetype)initWithToken:(MidtransTransactionTokenResponse *)token
            paymentMethodName:(MidtransPaymentListModel *)paymentMethod
                  statusModel:(VTPaymentStatusXLTunaiViewModel *)statusModel;

@end
