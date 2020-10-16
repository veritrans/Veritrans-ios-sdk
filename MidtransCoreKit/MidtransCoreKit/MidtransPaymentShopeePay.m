//
//  MidtransPaymentGOPAY.m
//  MidtransCoreKit
//
//  Created by Vanbungkring on 11/28/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import "MidtransPaymentShopeePay.h"

@implementation MidtransPaymentShopeePay
- (NSDictionary *)dictionaryValue {
    return @{@"payment_type":MIDTRANS_PAYMENT_SHOPEEPAY};
}
@end
