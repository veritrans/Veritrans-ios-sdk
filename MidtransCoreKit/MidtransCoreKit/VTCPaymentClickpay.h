//
//  VTCPaymentClickpay.h
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 2/29/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTPayment.h"
#import "VTMandiriClickpay.h"

@interface VTCPaymentClickpay : VTPayment

- (void)chargeWithClickpay:(VTMandiriClickpay *)clickpay callback:(void(^)(id response, NSError *error))callback;

@end
