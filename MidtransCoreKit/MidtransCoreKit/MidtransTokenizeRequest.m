//
//  MidtransTokenizeRequest.m
//  iossdk-gojek
//
//  Created by Akbar Taufiq Herlangga on 3/10/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MidtransTokenizeRequest.h"
#import "MidtransConfig.h"
#import "MidtransHelper.h"
#import "MidtransCreditCardHelper.h"
#import "MidtransCreditCardConfig.h"

@interface MidtransTokenizeRequest()
@property (nonatomic, readwrite) NSString *type;
@property (nonatomic, readwrite) NSString *cvv;
@property (nonatomic, readwrite) MTCreditCardPaymentType tokenType;
@end

@implementation MidtransTokenizeRequest

- (instancetype)initWithCreditCard:(MidtransCreditCard *)creditCard
                       grossAmount:(NSNumber *)grossAmount {
    if (self = [super init]) {
        self.creditCard = creditCard;
        self.cvv = creditCard.cvv;
        self.grossAmount = grossAmount;
        self.tokenType = MTCreditCardPaymentTypeNormal;
    }
    return self;
}
- (instancetype)initWithCreditCard:(MidtransCreditCard *)creditCard
                       grossAmount:(NSNumber *)grossAmount
                       installment:(BOOL)installment
                   installmentTerm:(NSNumber *)installmentTerm{
    if (self = [super init]) {
        self.creditCard = creditCard;
        self.installment = installment;
        self.installmentTerm = installmentTerm;
        self.cvv = creditCard.cvv;
        self.grossAmount = grossAmount;
        self.tokenType = MTCreditCardPaymentTypeNormal;
    }
    return self;
}
- (instancetype)initWithTwoClickToken:(NSString *)token
                                  cvv:(NSString *)cvv
                          grossAmount:(NSNumber *)grossAmount
                          installment:(BOOL)installment
                      installmentTerm:(NSNumber *)installmentTerm {
    if (self = [super init]) {
        self.grossAmount = grossAmount;
        self.installment = installment;
        self.installmentTerm = installmentTerm;
        self.token = token;
        self.cvv = cvv;
        self.tokenType = MTCreditCardPaymentTypeTwoclick;
    }
    return self;
    
}

- (instancetype)initWithTwoClickToken:(NSString *)token
                                  cvv:(NSString *)cvv
                          grossAmount:(NSNumber *)grossAmount {
    if (self = [super init]) {
        self.grossAmount = grossAmount;
        self.token = token;
        self.cvv = cvv;
        self.tokenType = MTCreditCardPaymentTypeTwoclick;
    }
    return self;
}

- (instancetype)initWithCreditCardToken:(NSString *)token
                                    cvv:(NSString *)cvv
                            grossAmount:(NSNumber *)grossAmount
                                 secure:(BOOL)secure
                       paymentTokenType:(MTCreditCardPaymentType)tokenType {
    
    if (self = [super init]) {
        self.token = token;
        self.cvv = cvv;
        self.grossAmount = grossAmount;
        self.secure = secure;
        self.tokenType = tokenType;
    }
    return self;
}

- (NSDictionary *)dictionaryValue {
    NSMutableDictionary *result = [NSMutableDictionary new];
    switch ([CONFIG currency]) {
        case MidtransCurrencyIDR:
            self.grossAmount = [NSNumber numberWithInteger:self.grossAmount.integerValue];
            break;
        case MidtransCurrencySGD:
            self.grossAmount = [NSNumber numberWithDouble:self.grossAmount.doubleValue];
            break;
        default:
            self.grossAmount = [NSNumber numberWithInteger:self.grossAmount.integerValue];
            break;
    }
    switch (self.tokenType) {
        case MTCreditCardPaymentTypeTwoclick: {
            [result setDictionary:@{@"client_key":[CONFIG clientKey],
                                    @"gross_amount":[MidtransHelper nullifyIfNil:self.grossAmount],
                                    @"currency":[MidtransHelper stringFromCurrency:[CONFIG currency]],
                                    @"two_click":@"true",
                                    @"token_id":[MidtransHelper nullifyIfNil:self.token]}];
            if (self.cvv) {
                [result setObject:self.cvv forKey:@"card_cvv"];
            }
            break;
        } case MTCreditCardPaymentTypeNormal: {
            [result setDictionary:@{@"client_key":[CONFIG clientKey],
                                    @"card_number":self.creditCard.number,
                                    @"card_type":[MidtransCreditCardHelper nameFromString: self.creditCard.number],
                                    @"gross_amount":[MidtransHelper nullifyIfNil:self.grossAmount],
                                    @"currency":[MidtransHelper stringFromCurrency:[CONFIG currency]]
                                    }];
            if (self.creditCard.expiryYear) {
                [result setObject:self.creditCard.expiryYear forKey:@"card_exp_year"];
            }
            if (self.creditCard.expiryMonth) {
                [result setObject:self.creditCard.expiryMonth forKey:@"card_exp_month"];
            }
            if (self.cvv) {
                [result setObject:self.cvv forKey:@"card_cvv"];
            }
            break;
        } default: {
            [result setDictionary:@{@"client_key":[CONFIG clientKey],
                                    @"card_number":self.creditCard.number,
                                    @"card_type":[MidtransCreditCardHelper nameFromString: self.creditCard.number],
                                    @"gross_amount":[MidtransHelper nullifyIfNil:self.grossAmount],
                                    @"currency":[MidtransHelper stringFromCurrency:[CONFIG currency]],
                                    @"installment":self.installment? @"true":@"false",
                                    @"installment_term":[MidtransHelper nullifyIfNil:self.installmentTerm],
                                    @"two_click":self.twoClick? @"true":@"false"}];
            if (self.creditCard.expiryYear) {
                [result setObject:self.creditCard.expiryYear forKey:@"card_exp_year"];
            }
            if (self.creditCard.expiryMonth) {
                [result setObject:self.creditCard.expiryMonth forKey:@"card_exp_month"];
            }
            if (self.cvv) {
                [result setObject:self.cvv forKey:@"card_cvv"];
            }
            break;
        }
    }
    
    if (CC_CONFIG.channel) {
        [result setObject:CC_CONFIG.channel forKey:@"channel"];
    }
    
    if (CC_CONFIG.acquiringBankString) {
        [result setObject:CC_CONFIG.acquiringBankString forKey:@"bank"];
    }
    
    if (self.installment) {
        [result setObject:@"true" forKey:@"installment"];
        [result setObject:self.installmentTerm forKey:@"installment_term"];
        
    }
    if (self.point) {
         [result setObject:@"true" forKey:@"point"];
    }
    if (CC_CONFIG.preauthEnabled) {
        result[@"type"] = @"authorize";
    }
    
    [result setObject:@"ios" forKey:@"x_source"];
    
    return result;
}

@end
