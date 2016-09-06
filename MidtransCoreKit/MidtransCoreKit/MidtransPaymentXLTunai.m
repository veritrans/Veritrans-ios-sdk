//
//  VTPaymentXLTunai.m
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 8/8/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MidtransPaymentXLTunai.h"

@interface MidtransPaymentXLTunai()
@property (nonatomic) MidtransTransactionTokenResponse *token;
@end

@implementation MidtransPaymentXLTunai

- (instancetype _Nonnull)initWithToken:(MidtransTransactionTokenResponse *_Nonnull)token {
    if (self = [super init]) {
        self.token = token;
    }
    return self;
}

- (NSString *)paymentType {
    return MIDTRANS_PAYMENT_XL_TUNAI;
}
- (NSDictionary *)dictionaryValue {
    return @{@"transaction_id" : self.token.tokenId};
}
- (NSString *)chargeURL {
    return ENDPOINT_CHARGE_XL_TUNAI;
}
- (MidtransTransactionTokenResponse *)snapToken {
    return self.token;
}

@end
