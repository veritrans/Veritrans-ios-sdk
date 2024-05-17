//
//  MidtransPaymentKredivo.m
//  MidtransCoreKit
//
//  Created by Muhammad Masykur on 14/05/24.
//  Copyright © 2024 Midtrans. All rights reserved.
//

#import "MidtransPaymentKredivo.h"
#import "MidtransHelper.h"
#import "MidtransConstant.h"

@implementation MidtransPaymentKredivo

- (NSDictionary *)dictionaryValue {
    return @{@"payment_type":MIDTRANS_PAYMENT_KREDIVO};
}
    
@end
