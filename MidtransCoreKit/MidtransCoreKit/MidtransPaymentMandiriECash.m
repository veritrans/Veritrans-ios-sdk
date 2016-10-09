//
//  VTPaymentMandiriECash.m
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 6/13/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MidtransPaymentMandiriECash.h"
#import "MidtransConstant.h"

@implementation MidtransPaymentMandiriECash

- (NSDictionary *)dictionaryValue {
    return @{@"payment_type":MIDTRANS_PAYMENT_MANDIRI_ECASH};
}

@end
