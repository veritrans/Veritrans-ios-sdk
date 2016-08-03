//
//  VTPaymentEpayBRI.m
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 6/14/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTPaymentEpayBRI.h"
#import "VTHelper.h"
#import "VTConstant.h"

@interface VTPaymentEpayBRI()
@property (nonatomic) TransactionTokenResponse *token;
@end

@implementation VTPaymentEpayBRI

- (instancetype _Nonnull)initWithToken:(TransactionTokenResponse *_Nonnull)token {
    if (self = [super init]) {
        self.token = token;
    }
    return self;
}
- (NSString *)paymentType {
    return VT_PAYMENT_BRI_EPAY;
}

- (NSDictionary *)dictionaryValue {
    return @{@"transaction_id":self.token.tokenId};
}

- (NSString *)chargeURL {
    return ENDPOINT_CHARGE_BRI_EPAY;
}

- (TransactionTokenResponse *)snapToken {
    return self.token;
}

@end
