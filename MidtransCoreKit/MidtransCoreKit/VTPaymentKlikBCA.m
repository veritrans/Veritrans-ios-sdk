//
//  VTPaymentKlikBCA.m
//  MidtransCoreKit
//
//  Created by Arie on 6/16/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTPaymentKlikBCA.h"
#import "VTConstant.h"
@interface VTPaymentKlikBCA()
@property (nonatomic) NSString *klikBCAUserId;
@property (nonatomic) TransactionTokenResponse *token;
@end;

@implementation VTPaymentKlikBCA

- (instancetype _Nonnull)initWithKlikBCAUserId:(NSString * _Nonnull)userId token:(TransactionTokenResponse *_Nonnull)token {
    if (self = [super init]) {
        self.klikBCAUserId = userId;
        self.token = token;
    }
    return self;
}

- (NSString *)paymentType {
    return VT_PAYMENT_KLIK_BCA;
}
- (NSDictionary *)dictionaryValue {
    return @{@"user_id" : self.klikBCAUserId,
             @"transaction_id" : self.token.tokenId};
}
- (NSString *)chargeURL {
    return ENDPOINT_CHARGE_KLIKBCA;
}
- (TransactionTokenResponse *)snapToken {
    return self.token;
}
@end
