//
//  VTPaymentEpayBRI.m
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 6/14/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MidtransPaymentEpayBRI.h"
#import "MidtransHelper.h"
#import "VTConstant.h"

@interface MidtransPaymentEpayBRI()
@property (nonatomic) MidtransTransactionTokenResponse *token;
@end

@implementation MidtransPaymentEpayBRI

- (instancetype _Nonnull)initWithToken:(MidtransTransactionTokenResponse *_Nonnull)token {
    if (self = [super init]) {
        self.token = token;
    }
    return self;
}
- (NSString *)paymentType {
    return MIDTRANS_PAYMENT_BRI_EPAY;
}

- (NSDictionary *)dictionaryValue {
    return @{@"transaction_id":self.token.tokenId};
}

- (NSString *)chargeURL {
    return ENDPOINT_CHARGE_BRI_EPAY;
}

- (MidtransTransactionTokenResponse *)snapToken {
    return self.token;
}

@end
