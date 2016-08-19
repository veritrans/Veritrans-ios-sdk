//
//  VTPaymentMandiriClickpay.m
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 6/14/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTPaymentMandiriClickpay.h"
#import "VTConstant.h"

@interface VTPaymentMandiriClickpay()
@property (nonatomic) NSString *cardNumber;
@property (nonatomic) TransactionTokenResponse *token;
@property (nonatomic) NSString *clickpayToken;
@property (nonatomic) NSNumber *grossAmount;
@end

@implementation VTPaymentMandiriClickpay

- (instancetype _Nonnull)initWithCardNumber:(NSString *_Nonnull)cardNumber clickpayToken:(NSString *_Nonnull)clickpayToken token:(TransactionTokenResponse *_Nonnull)token {
    if (self = [super init]) {
        self.cardNumber = [cardNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
        self.token = token;
        self.clickpayToken = clickpayToken;
    }
    return self;
}

- (NSString *)paymentType {
    return VT_PAYMENT_MANDIRI_CLICKPAY;
}

- (NSDictionary *)dictionaryValue {
    return @{@"transaction_id":self.token.tokenId,
             @"mandiri_card_no":self.cardNumber,
             @"input3":[VTMandiriClickpayHelper generateInput3],
             @"token_response":self.clickpayToken};
}

- (NSString *)chargeURL {
    return ENDPOINT_CHARGE_MANDIRI_CLICKPAY;
}

- (TransactionTokenResponse *)snapToken {
    return self.token;
}

@end
