//
//  VTPaymentCStore.m
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 6/13/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTPaymentCStore.h"

@interface VTPaymentCStore()
@property (nonatomic) TransactionTokenResponse *token;
@end

@implementation VTPaymentCStore

- (instancetype _Nonnull)initWithToken:(TransactionTokenResponse *_Nonnull)token {
    if (self = [super init]) {
        self.token = token;
    }
    return self;
}

- (NSString *)paymentType {
    return VT_PAYMENT_CSTORE;
}

- (NSDictionary *)dictionaryValue {
    return @{@"transaction_id":self.token.tokenId};
}

- (NSString *)chargeURL {
    return ENDPOINT_CHARGE_INDOMARET;
}

- (TransactionTokenResponse *)snapToken {
    return self.token;
}

@end
