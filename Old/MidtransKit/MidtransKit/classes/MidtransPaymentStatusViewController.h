//
//  MidtransPaymentStatusViewController.h
//  MidtransKit
//
//  Created by Arie on 10/31/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MidtransUIPaymentController.h"
@class MidtransTransactionResult;
@interface MidtransPaymentStatusViewController : MidtransUIPaymentController
- (instancetype)initWithTransactionResult:(MidtransTransactionResult *)result;
@end
