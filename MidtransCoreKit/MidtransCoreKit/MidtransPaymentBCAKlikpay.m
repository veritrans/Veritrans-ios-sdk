//
//  VTPaymentBCAKlikpay.m
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 6/13/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MidtransPaymentBCAKlikpay.h"
#import "MidtransHelper.h"
#import "VTConstant.h"

@interface MidtransPaymentBCAKlikpay()
@property (nonatomic) MidtransTransactionTokenResponse *token;
@end

@implementation MidtransPaymentBCAKlikpay

- (instancetype _Nonnull) initWithToken:(MidtransTransactionTokenResponse *_Nonnull)token {
    if (self = [super init]) {
        self.token = token;
    }
    return self;
}

- (NSString *)paymentType {
    return MIDTRANS_PAYMENT_BCA_KLIKPAY;
}

- (NSDictionary *)dictionaryValue {
    return @{@"transaction_id":self.token.tokenId};
}

- (NSString *)chargeURL {
    return ENDPOINT_CHARGE_BCA_KLIKPAY;
}

- (MidtransTransactionTokenResponse *)snapToken {
    return self.token;
}
@end
