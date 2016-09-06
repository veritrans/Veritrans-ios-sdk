//
//  VTPendingStatusController.h
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 8/29/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTPaymentController.h"
#import <MidtransCoreKit/MidtransCoreKit.h>

@interface VTPendingStatusController : VTPaymentController
- (instancetype)initWithToken:(MidtransTransactionTokenResponse *)token paymentMethodName:(MidtransPaymentListModel *)paymentMethod result:(MidtransTransactionResult *)result;
@end
