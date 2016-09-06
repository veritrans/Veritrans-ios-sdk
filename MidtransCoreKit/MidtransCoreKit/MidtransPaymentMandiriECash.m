//
//  VTPaymentMandiriECash.m
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 6/13/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MidtransPaymentMandiriECash.h"
#import "VTConstant.h"

@interface MidtransPaymentMandiriECash()
@property (nonatomic) MidtransTransactionTokenResponse *token;
@end

@implementation MidtransPaymentMandiriECash

- (instancetype _Nonnull)initWithToken:(MidtransTransactionTokenResponse * _Nonnull)token {
    if (self = [super init]) {
        self.token = token;
    }
    return self;
}

- (NSString *)paymentType {
    return MIDTRANS_PAYMENT_MANDIRI_ECASH;
}
- (NSDictionary *)dictionaryValue {
    return @{@"transaction_id":self.token.tokenId};
}

- (NSString *)chargeURL {
    return ENDPOINT_CHARGE_MANDIRI_ECASH;
}
- (MidtransTransactionTokenResponse *)snapToken {
    return self.token;
}
@end
