//
//  VTIndomaretSuccessController.h
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 6/13/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTPaymentController.h"
#import "VTPaymentStatusViewModel.h"

@interface VTIndomaretSuccessController : VTPaymentController
- (instancetype)initWithCustomerDetails:(VTCustomerDetails *)customerDetails itemDetails:(NSArray<VTItemDetail *> *)itemDetails transactionDetails:(VTTransactionDetails *)transactionDetails paymentMethodName:(VTPaymentListModel *)paymentMethod statusModel:(VTPaymentStatusViewModel *)statusModel;
@end
