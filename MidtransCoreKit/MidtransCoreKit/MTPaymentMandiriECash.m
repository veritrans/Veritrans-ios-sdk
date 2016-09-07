//
//  VTPaymentMandiriECash.m
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 6/13/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MTPaymentMandiriECash.h"
#import "MTConstant.h"

@interface MTPaymentMandiriECash()
@property (nonatomic) MTTransactionTokenResponse *token;
@end

@implementation MTPaymentMandiriECash

- (instancetype _Nonnull)initWithToken:(MTTransactionTokenResponse * _Nonnull)token {
    if (self = [super init]) {
        self.token = token;
    }
    return self;
}

- (NSString *)paymentType {
    return MT_PAYMENT_MANDIRI_ECASH;
}
- (NSDictionary *)dictionaryValue {
    return @{@"transaction_id":self.token.tokenId};
}

- (NSString *)chargeURL {
    return ENDPOINT_CHARGE_MANDIRI_ECASH;
}
- (MTTransactionTokenResponse *)snapToken {
    return self.token;
}
@end
