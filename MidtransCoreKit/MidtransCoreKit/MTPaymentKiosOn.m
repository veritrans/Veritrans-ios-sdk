//
//  VTPaymentKiosOn.m
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 8/29/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MTPaymentKiosOn.h"

@interface MTPaymentKiosOn()
@property (nonatomic) MTTransactionTokenResponse *token;
@end

@implementation MTPaymentKiosOn

- (instancetype _Nonnull)initWithToken:(MTTransactionTokenResponse *_Nonnull)token {
    if (self = [super init]) {
        self.token = token;
    }
    return self;
}

- (NSString *)paymentType {
    return MT_PAYMENT_KIOS_ON;
}

- (NSDictionary *)dictionaryValue {
    return @{@"transaction_id" : self.token.tokenId};
}

- (NSString *)chargeURL {
    return ENDPOINT_CHARGE_KIOS_ON;
}

- (MTTransactionTokenResponse *)snapToken {
    return self.token;
}

@end
