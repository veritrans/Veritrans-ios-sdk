//
//  MidtransPaymentAkulaku.m
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 23/10/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import "MidtransPaymentAkulaku.h"
#import "MidtransHelper.h"
#import "MidtransConstant.h"

@implementation MidtransPaymentAkulaku

- (NSDictionary *)dictionaryValue {
    return @{@"payment_type":MIDTRANS_PAYMENT_AKULAKU};
}
    
@end
