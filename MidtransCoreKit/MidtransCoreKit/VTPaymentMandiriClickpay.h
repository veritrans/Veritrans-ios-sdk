//
//  VTPaymentMandiriClickpay.h
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 2/25/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <MidtransCoreKit/MidtransCoreKit.h>
#import "VTMandiriClickpay.h"

@interface VTPaymentMandiriClickpay : VTPayment

- (void)payWithData:(VTMandiriClickpay *)data callback:(void(^)(id response, NSError *error))callback;

@end
