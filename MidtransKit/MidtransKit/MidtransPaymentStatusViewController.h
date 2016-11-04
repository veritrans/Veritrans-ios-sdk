//
//  MidtransPaymentStatusViewController.h
//  MidtransKit
//
//  Created by Arie on 10/31/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MidtransUIBaseViewController.h"
@class MidtransTransactionResult;
@interface MidtransPaymentStatusViewController : MidtransUIBaseViewController
- (instancetype)initWithTransactionResult:(MidtransTransactionResult *)result;
@end
