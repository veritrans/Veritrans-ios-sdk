//
//  MidtransPaymentUOB.m
//  MidtransCoreKit
//
//  Created by Muhammad Fauzi Masykur on 05/05/21.
//  Copyright © 2021 Midtrans. All rights reserved.
//

#import "MidtransPaymentUOB.h"
#import "MidtransConstant.h"

@implementation MidtransPaymentUOB

- (NSDictionary *)dictionaryValue {
    return @{@"payment_type":MIDTRANS_PAYMENT_UOB};
}

@end
