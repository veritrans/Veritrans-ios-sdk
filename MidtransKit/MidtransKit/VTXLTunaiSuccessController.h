//
//  VTXLTunaiSuccessController.h
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 8/8/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTPaymentController.h"
#import "VTPaymentStatusXLTunaiViewModel.h"

@interface VTXLTunaiSuccessController : VTPaymentController

- (instancetype)initWithToken:(TransactionTokenResponse *)token
            paymentMethodName:(VTPaymentListModel *)paymentMethod
                  statusModel:(VTPaymentStatusXLTunaiViewModel *)statusModel;

@end
