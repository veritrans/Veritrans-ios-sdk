//
//  VTPaymentXLTunai.m
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 8/8/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTPaymentXLTunai.h"

@interface VTPaymentXLTunai()
@property (nonatomic) TransactionTokenResponse *token;
@end

@implementation VTPaymentXLTunai

- (instancetype _Nonnull)initWithToken:(TransactionTokenResponse *_Nonnull)token {
    if (self = [super init]) {
        self.token = token;
    }
    return self;
}

- (NSString *)paymentType {
    return VT_PAYMENT_XL_TUNAI;
}
- (NSDictionary *)dictionaryValue {
    return @{@"transaction_id" : self.token.tokenId};
}
- (NSString *)chargeURL {
    return ENDPOINT_CHARGE_XL_TUNAI;
}
- (TransactionTokenResponse *)snapToken {
    return self.token;
}

@end
