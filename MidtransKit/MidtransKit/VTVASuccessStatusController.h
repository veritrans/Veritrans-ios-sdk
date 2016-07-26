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
- (instancetype)initWithCustomerDetails:(VTCustomerDetails *)customerDetails
                            itemDetails:(NSArray<VTItemDetail *> *)itemDetails
                     transactionDetails:(VTTransactionDetails *)transactionDetails
                      paymentMethodName:(VTPaymentListModel *)paymentMethod
                            statusModel:(VTVATransactionStatusViewModel *)statusModel;
@end
