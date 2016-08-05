//
//  VTPaymentCIMBClicks.m
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 6/13/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTPaymentCIMBClicks.h"
#import "VTConstant.h"

@interface VTPaymentCIMBClicks()
@property (nonatomic) TransactionTokenResponse *token;
@end

@implementation VTPaymentCIMBClicks

- (instancetype _Nonnull)initWithToken:(TransactionTokenResponse * _Nonnull)token {
    if (self = [super init]) {
        self.token = token;
    }
    return self;
}

- (NSString *)paymentType {
    return VT_PAYMENT_CIMB_CLICKS;
}

- (NSDictionary *)dictionaryValue {
    return @{@"transaction_id":self.token.tokenId};
}

- (NSString *)chargeURL {
    return ENDPOINT_CHARGE_CIMB_CLICKS;
}

- (TransactionTokenResponse *)snapToken {
    return self.token;
}

@end
