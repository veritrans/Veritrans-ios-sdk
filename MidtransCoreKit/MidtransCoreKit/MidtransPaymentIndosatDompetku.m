//
//  VTPaymentIndosatDompetku.m
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 8/8/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MidtransPaymentIndosatDompetku.h"

@interface MidtransPaymentIndosatDompetku()
@property (nonatomic) NSString *msisdn;
@end

@implementation MidtransPaymentIndosatDompetku

- (instancetype _Nonnull)initWithMSISDN:(NSString *_Nonnull)msisdn {
    if (self = [super init]) {
        self.msisdn = msisdn;
    }
    return self;
}

- (NSDictionary *)dictionaryValue {
    return @{@"payment_type":MIDTRANS_PAYMENT_INDOSAT_DOMPETKU,
             @"payment_params":@{@"msisdn" : self.msisdn}};
}

@end
