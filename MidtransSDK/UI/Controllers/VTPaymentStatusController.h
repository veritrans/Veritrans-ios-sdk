//
//  VTPaymentStatusController.h
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 3/7/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MidtransUIBaseViewController.h"
#import <MidtransCoreKit/MidtransCoreKit.h>

@interface VTPaymentStatusController : MidtransUIBaseViewController

+ (instancetype)successTransactionWithResult:(MidtransTransactionResult *)result
                                       token:(MidtransTransactionTokenResponse *)token
                               paymentMethod:(MidtransPaymentListModel *)paymentMethod;
+ (instancetype)errorTransactionWithError:(NSError *)error
                                    token:(MidtransTransactionTokenResponse *)token
                            paymentMethod:(MidtransPaymentListModel *)paymentMethod;
+ (instancetype)pendingTransactionWithResult:(MidtransTransactionResult *)result
                                       token:(MidtransTransactionTokenResponse *)token
                               paymentMethod:(MidtransPaymentListModel *)paymentMethod;

@end
