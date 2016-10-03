//
//  VTPaymentXLTunai.m
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 8/8/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MidtransPaymentXLTunai.h"

@interface MidtransPaymentXLTunai()
@end

@implementation MidtransPaymentXLTunai

- (NSDictionary *)dictionaryValue {
    return @{@"payment_type" : MIDTRANS_PAYMENT_XL_TUNAI};
}

@end
