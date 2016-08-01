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
@property (nonatomic, readwrite) NSString *token;
@property (nonatomic, readwrite) VTCreditCardPaymentFeature creditCardPaymentFeature;
@end

@implementation VTPaymentCreditCard

- (instancetype)initWithFeature:(VTCreditCardPaymentFeature)feature
                          token:(NSString *)token {
    if (self = [super init]) {
        self.creditCardPaymentFeature = feature;
        self.token = token;
        self.type = @"authorize";
    }
    return self;
}

- (instancetype)initWithToken:(NSString *)token {
    if (self = [super init]) {
        self.token = token;
        self.type = @"authorize";
    }
    return self;
}

- (NSString *)paymentType {
    return VT_PAYMENT_CREDIT_CARD;
}

- (NSDictionary *)dictionaryValue {
    return @{@"token_id":self.token};
}

- (NSString *)chargeURL {
    return ENDPOINT_CHARGE_CC;
}

@end
