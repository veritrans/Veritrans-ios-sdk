//
//  VTPaymentCStore.m
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 6/13/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MTPaymentCStore.h"

@interface MTPaymentCStore()
@property (nonatomic) MidtransTransactionTokenResponse *token;
@end

@implementation MTPaymentCStore

- (instancetype _Nonnull)initWithToken:(MidtransTransactionTokenResponse *_Nonnull)token {
    if (self = [super init]) {
        self.token = token;
    }
    return self;
}

- (NSString *)paymentType {
    return MIDTRANS_PAYMENT_CSTORE;
}

- (NSDictionary *)dictionaryValue {
    return @{@"transaction_id":self.token.tokenId};
}

- (NSString *)chargeURL {
    return ENDPOINT_CHARGE_INDOMARET;
}

- (MidtransTransactionTokenResponse *)snapToken {
    return self.token;
}

@end
