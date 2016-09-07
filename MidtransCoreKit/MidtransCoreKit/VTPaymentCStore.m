//
//  VTPaymentCStore.m
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 6/13/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTPaymentCStore.h"

@interface VTPaymentCStore()
@property (nonatomic) MTTransactionTokenResponse *token;
@end

@implementation VTPaymentCStore

- (instancetype _Nonnull)initWithToken:(MTTransactionTokenResponse *_Nonnull)token {
    if (self = [super init]) {
        self.token = token;
    }
    return self;
}

- (NSString *)paymentType {
    return MT_PAYMENT_CSTORE;
}

- (NSDictionary *)dictionaryValue {
    return @{@"transaction_id":self.token.tokenId};
}

- (NSString *)chargeURL {
    return ENDPOINT_CHARGE_INDOMARET;
}

- (MTTransactionTokenResponse *)snapToken {
    return self.token;
}

@end
