//
//  MTPaymentCreditCard.m
//  iossdk-gojek
//
//  Created by Akbar Taufiq Herlangga on 3/10/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MTPaymentCreditCard.h"
#import "MidtransHelper.h"
#import "MidtransConfig.h"
#import "MidtransCreditCardConfig.h"

@interface MTPaymentCreditCard()
@property (nonatomic) MTCreditCardPaymentFeature creditCardPaymentFeature;
@property (nonatomic) MidtransTransactionTokenResponse *_Nonnull token;
@property (nonatomic) NSString *_Nonnull creditCardToken;
@end

@implementation MTPaymentCreditCard

- (instancetype)initWithFeature:(MTCreditCardPaymentFeature)feature
                creditCardToken:(NSString *_Nonnull)creditCardToken
                          token:(MidtransTransactionTokenResponse *_Nonnull)token {
    if (self = [super init]) {
        self.creditCardPaymentFeature = feature;
        self.token = token;
        self.creditCardToken = creditCardToken;
        self.type = @"authorize";
    }
    return self;
}

- (instancetype _Nonnull)initWithCreditCardToken:(NSString *_Nonnull)creditCardToken token:(MidtransTransactionTokenResponse *_Nonnull)token {
    if (self = [super init]) {
        self.creditCardToken = creditCardToken;
        self.token = token;
        self.type = @"authorize";
    }
    return self;
}

- (NSString *)paymentType {
    return MIDTRANS_PAYMENT_CREDIT_CARD;
}

- (NSDictionary *)dictionaryValue {
    NSString *fullName = [NSString stringWithFormat:@"%@ %@", self.token.customerDetails.firstName, self.token.customerDetails.lastName];
    
    NSDictionary *paymentDetail = @{@"full_name":fullName,
                                    @"phone":self.token.customerDetails.phone,
                                    @"email":self.token.customerDetails.email};
    
    return @{@"transaction_id":self.token.tokenId,
             @"token_id":self.creditCardToken,
             @"save_card":@([CC_CONFIG saveCard]),
             @"payment_detail":paymentDetail};
}

- (NSString *)chargeURL {
    return ENDPOINT_CHARGE_CC;
}

- (MidtransTransactionTokenResponse *)snapToken {
    return self.token;
}

@end
