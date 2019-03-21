//
//  MIDIndomaretPayment.m
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 27/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import "MIDIndomaretPayment.h"

@implementation MIDIndomaretPayment

- (NSDictionary *)dictionaryValue {
    return @{@"payment_type": @"indomaret"};
}

@end
