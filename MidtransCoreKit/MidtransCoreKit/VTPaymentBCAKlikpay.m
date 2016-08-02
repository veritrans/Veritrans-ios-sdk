//
//  VTPaymentBCAKlikpay.m
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 6/13/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTPaymentBCAKlikpay.h"
#import "VTHelper.h"
#import "VTConstant.h"

@interface VTPaymentBCAKlikpay()
@property (nonatomic) TransactionTokenResponse *token;
@end

@implementation VTPaymentBCAKlikpay

- (instancetype _Nonnull) initWithToken:(TransactionTokenResponse *_Nonnull)token {
    if (self = [super init]) {
        self.token = token;
    }
    return self;
}

- (NSString *)paymentType {
    return VT_PAYMENT_BCA_KLIKPAY;
}

- (NSDictionary *)dictionaryValue {
    return @{@"transaction_id":self.token.tokenId};
}

- (NSString *)chargeURL {
    return ENDPOINT_CHARGE_BCA_KLIKPAY;
}

- (TransactionTokenResponse *)snapToken {
    return self.token;
}
@end
