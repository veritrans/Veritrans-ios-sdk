//
//  VTPaymentTelkomselCash.m
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 8/8/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MidtransPaymentTelkomselCash.h"

@interface MidtransPaymentTelkomselCash()
@property (nonatomic) NSString *msisdn;
@end

@implementation MidtransPaymentTelkomselCash

- (instancetype _Nonnull)initWithMSISDN:(NSString *_Nonnull)msisdn {
    if (self = [super init]) {
        self.msisdn = msisdn;
    }
    return self;
}

- (NSDictionary *)dictionaryValue {
    return @{@"payment_type":MIDTRANS_PAYMENT_TELKOMSEL_CASH,
             @"payment_params":@{@"customer":self.msisdn}};
}

@end
