//
//  VTPaymentKlikBCA.m
//  MidtransCoreKit
//
//  Created by Arie on 6/16/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MTPaymentKlikBCA.h"
#import "MidtransConstant.h"
@interface MTPaymentKlikBCA()
@property (nonatomic) NSString *klikBCAUserId;
@property (nonatomic) MidtransTransactionTokenResponse *token;
@end;

@implementation MTPaymentKlikBCA

- (instancetype _Nonnull)initWithKlikBCAUserId:(NSString * _Nonnull)userId token:(MidtransTransactionTokenResponse *_Nonnull)token {
    if (self = [super init]) {
        self.klikBCAUserId = userId;
        self.token = token;
    }
    return self;
}

- (NSString *)paymentType {
    return MIDTRANS_PAYMENT_KLIK_BCA;
}
- (NSDictionary *)dictionaryValue {
    return @{@"user_id" : self.klikBCAUserId,
             @"transaction_id" : self.token.tokenId};
}
- (NSString *)chargeURL {
    return ENDPOINT_CHARGE_KLIKBCA;
}
- (MidtransTransactionTokenResponse *)snapToken {
    return self.token;
}
@end
