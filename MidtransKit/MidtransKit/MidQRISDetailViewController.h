//
//  MidQRISDetailViewController.h
//  MidtransKit
//
//  Created by Vanbungkring on 11/28/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import "MidtransUIPaymentController.h"
@class MidtransTransactionResult;
@interface MidQRISDetailViewController : MidtransUIPaymentController
@property (nonatomic,strong) MidtransTransactionResult *result;
@end
