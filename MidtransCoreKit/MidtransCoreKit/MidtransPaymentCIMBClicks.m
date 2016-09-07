//
//  VTPaymentCIMBClicks.m
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 6/13/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MidtransPaymentCIMBClicks.h"
#import "MidtransConstant.h"

@interface MidtransPaymentCIMBClicks()
@property (nonatomic) MidtransTransactionTokenResponse *token;
@end

@implementation MidtransPaymentCIMBClicks

- (instancetype _Nonnull)initWithToken:(MidtransTransactionTokenResponse * _Nonnull)token {
    if (self = [super init]) {
        self.token = token;
    }
    return self;
}

- (NSString *)paymentType {
    return MIDTRANS_PAYMENT_CIMB_CLICKS;
}

- (NSDictionary *)dictionaryValue {
    return @{@"transaction_id":self.token.tokenId};
}

- (NSString *)chargeURL {
    return ENDPOINT_CHARGE_CIMB_CLICKS;
}

- (MidtransTransactionTokenResponse *)snapToken {
    return self.token;
}

@end
