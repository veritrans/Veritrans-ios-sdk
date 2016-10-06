//
//  VTPaymentBCAKlikpay.m
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 6/13/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MidtransPaymentBCAKlikpay.h"
#import "MidtransHelper.h"
#import "MidtransConstant.h"

@implementation MidtransPaymentBCAKlikpay

- (NSDictionary *)dictionaryValue {
    return @{@"payment_type":MIDTRANS_PAYMENT_BCA_KLIKPAY};
}

@end
