//
//  VTPaymentKiosOn.m
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 8/29/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTPaymentKiosOn.h"

@interface VTPaymentKiosOn()
@property (nonatomic) TransactionTokenResponse *token;
@end

@implementation VTPaymentKiosOn

- (instancetype _Nonnull)initWithToken:(TransactionTokenResponse *_Nonnull)token {
    if (self = [super init]) {
        self.token = token;
    }
    return self;
}

- (NSString *)paymentType {
    return VT_PAYMENT_KIOS_ON;
}

- (NSDictionary *)dictionaryValue {
    return @{@"transaction_id" : self.token.tokenId};
}

- (NSString *)chargeURL {
    return ENDPOINT_CHARGE_KIOS_ON;
}

- (TransactionTokenResponse *)snapToken {
    return self.token;
}

@end
