//
//  MIDAlfamartPayment.m
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 13/03/19.
//  Copyright © 2019 Midtrans. All rights reserved.
//

#import "MIDAlfamartPayment.h"

@implementation MIDAlfamartPayment

- (NSDictionary *)dictionaryValue {
    return @{@"payment_type": @"alfamart"};
}

@end
