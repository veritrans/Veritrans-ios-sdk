//
//  VTPaymentEpayBRI.m
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 6/14/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MidtransPaymentEpayBRI.h"
#import "MidtransHelper.h"
#import "MidtransConstant.h"

@implementation MidtransPaymentEpayBRI

- (NSDictionary *)dictionaryValue {
    return @{@"payment_type":MIDTRANS_PAYMENT_BRI_EPAY};
}

@end
