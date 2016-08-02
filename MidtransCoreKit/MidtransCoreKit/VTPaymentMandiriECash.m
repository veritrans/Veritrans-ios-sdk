//
//  VTPaymentMandiriECash.m
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 6/13/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTPaymentMandiriECash.h"
#import "VTConstant.h"

@interface VTPaymentMandiriECash()
@property (nonatomic) TransactionTokenResponse *token;
@end

@implementation VTPaymentMandiriECash

- (instancetype _Nonnull)initWithToken:(TransactionTokenResponse * _Nonnull)token {
    if (self = [super init]) {
        self.token = token;
    }
    return self;
}

- (NSString *)paymentType {
    return VT_PAYMENT_MANDIRI_ECASH;
}
- (NSDictionary *)dictionaryValue {
    return @{@"transaction_id":self.token.tokenId};
}

- (NSString *)chargeURL {
    return ENDPOINT_CHARGE_MANDIRI_ECASH;
}
- (TransactionTokenResponse *)snapToken {
    return self.token;
}
@end
