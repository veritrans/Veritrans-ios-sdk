//
//  VTPaymentEpayBRI.m
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 6/14/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MTPaymentEpayBRI.h"
#import "VTHelper.h"
#import "MTConstant.h"

@interface MTPaymentEpayBRI()
@property (nonatomic) MTTransactionTokenResponse *token;
@end

@implementation MTPaymentEpayBRI

- (instancetype _Nonnull)initWithToken:(MTTransactionTokenResponse *_Nonnull)token {
    if (self = [super init]) {
        self.token = token;
    }
    return self;
}
- (NSString *)paymentType {
    return MT_PAYMENT_BRI_EPAY;
}

- (NSDictionary *)dictionaryValue {
    return @{@"transaction_id":self.token.tokenId};
}

- (NSString *)chargeURL {
    return ENDPOINT_CHARGE_BRI_EPAY;
}

- (MTTransactionTokenResponse *)snapToken {
    return self.token;
}

@end
