//
//  MidGopayDetailViewController.h
//  MidtransKit
//
//  Created by Vanbungkring on 11/28/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import "MidtransUIPaymentController.h"

@interface MidGopayDetailViewController : MidtransUIPaymentController

- (instancetype)initWithResult:(MIDGopayResult *)result paymentMethod:(MIDPaymentDetail *)paymentMethod;

@end
