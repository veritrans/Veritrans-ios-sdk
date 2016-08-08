//
//  VTPaymentIndosatDompetku.m
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 8/8/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTPaymentIndosatDompetku.h"

@interface VTPaymentIndosatDompetku()
@property (nonatomic) NSString *msisdn;
@property (nonatomic) TransactionTokenResponse *token;
@end

@implementation VTPaymentIndosatDompetku

- (instancetype _Nonnull)initWithMSISDN:(NSString *_Nonnull)msisdn token:(TransactionTokenResponse *_Nonnull)token {
    if (self = [super init]) {
        self.msisdn = msisdn;
        self.token = token;
    }
    return self;
}

- (NSString *)paymentType {
    return VT_PAYMENT_INDOSAT_DOMPETKU;
}
- (NSDictionary *)dictionaryValue {
    return @{@"msisdn" : self.msisdn,
             @"transaction_id" : self.token.tokenId};
}
- (NSString *)chargeURL {
    return ENDPOINT_CHARGE_INDOSAT_DOMPETKU;
}
- (TransactionTokenResponse *)snapToken {
    return self.token;
}


@end
