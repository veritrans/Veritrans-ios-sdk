//
//  VTPaymentXLTunai.m
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 8/8/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MTPaymentXLTunai.h"

@interface MTPaymentXLTunai()
@property (nonatomic) MTTransactionTokenResponse *token;
@end

@implementation MTPaymentXLTunai

- (instancetype _Nonnull)initWithToken:(MTTransactionTokenResponse *_Nonnull)token {
    if (self = [super init]) {
        self.token = token;
    }
    return self;
}

- (NSString *)paymentType {
    return MT_PAYMENT_XL_TUNAI;
}
- (NSDictionary *)dictionaryValue {
    return @{@"transaction_id" : self.token.tokenId};
}
- (NSString *)chargeURL {
    return ENDPOINT_CHARGE_XL_TUNAI;
}
- (MTTransactionTokenResponse *)snapToken {
    return self.token;
}

@end
