//
//  VTPaymentKiosOn.m
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 8/29/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MidtransPaymentKiosOn.h"

@interface MidtransPaymentKiosOn()
@end

@implementation MidtransPaymentKiosOn

- (NSDictionary *)dictionaryValue {
    return @{@"payment_type" : MIDTRANS_PAYMENT_KIOS_ON};
}

@end
