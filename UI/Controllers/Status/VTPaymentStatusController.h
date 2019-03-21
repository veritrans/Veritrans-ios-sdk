//
//  VTPaymentStatusController.h
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 3/7/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MidtransUIBaseViewController.h"
#import "MIDPaymentDetail.h"

#import "MidtransSDK.h"

@interface VTPaymentStatusController : MidtransUIBaseViewController

+ (instancetype)successTransactionWithResult:(MIDPaymentResult *)result
                               paymentMethod:(MIDPaymentDetail *)paymentMethod;

+ (instancetype)errorTransactionWithError:(NSError *)error
                            paymentMethod:(MIDPaymentDetail *)paymentMethod;

+ (instancetype)pendingTransactionWithResult:(MIDPaymentResult *)result
                               paymentMethod:(MIDPaymentDetail *)paymentMethod;

@end
