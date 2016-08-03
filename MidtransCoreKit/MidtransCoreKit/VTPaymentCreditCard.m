//
//  VTPaymentCreditCard.m
//  iossdk-gojek
//
//  Created by Akbar Taufiq Herlangga on 3/10/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTPaymentCreditCard.h"
#import "VTHelper.h"
#import "VTConfig.h"

@interface VTPaymentCreditCard()
@property (nonatomic) VTCreditCardPaymentFeature creditCardPaymentFeature;
@property (nonatomic) TransactionTokenResponse *_Nonnull token;
@property (nonatomic) NSString *_Nonnull creditCardToken;
@end

@implementation VTPaymentCreditCard

- (instancetype)initWithFeature:(VTCreditCardPaymentFeature)feature
                creditCardToken:(NSString *_Nonnull)creditCardToken
                          token:(TransactionTokenResponse *_Nonnull)token {
    if (self = [super init]) {
        self.creditCardPaymentFeature = feature;
        self.token = token;
        self.creditCardToken = creditCardToken;
        self.type = @"authorize";
    }
    return self;
}

- (instancetype _Nonnull)initWithCreditCardToken:(NSString *_Nonnull)creditCardToken token:(TransactionTokenResponse *_Nonnull)token {
    if (self = [super init]) {
        self.creditCardToken = creditCardToken;
        self.token = token;
        self.type = @"authorize";
    }
    return self;
}

- (NSString *)paymentType {
    return VT_PAYMENT_CREDIT_CARD;
}

- (NSDictionary *)dictionaryValue {
    
    NSDictionary *paymentDetail =
    @{@"full_name":[NSString stringWithFormat:@"%@ %@", self.token.customerDetails.firstName, self.token.customerDetails.lastName],
      @"phone":self.token.customerDetails.phone,
      @"email":self.token.customerDetails.email};
    
    return @{@"transaction_id":self.token.tokenId,
             @"token_id":self.creditCardToken,
             @"payment_detail":paymentDetail};
}

- (NSString *)chargeURL {
    return ENDPOINT_CHARGE_CC;
}

- (TransactionTokenResponse *)snapToken {
    return self.token;
}

@end
