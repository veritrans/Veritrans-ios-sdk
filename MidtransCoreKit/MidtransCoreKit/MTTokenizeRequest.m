//
//  VTTokenizeRequest.m
//  iossdk-gojek
//
//  Created by Akbar Taufiq Herlangga on 3/10/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MTTokenizeRequest.h"
#import "MTConfig.h"
#import "MTHelper.h"
#import "MTTrackingManager.h"
#import "MTCreditCardHelper.h"
#import "MTCreditCardPaymentFeature.h"

@interface MTTokenizeRequest()
@property (nonatomic, readwrite) MTCreditCard *creditCard;
@property (nonatomic, readwrite) NSString *bank;
@property (nonatomic, readwrite) NSNumber *grossAmount;
@property (nonatomic, readwrite) BOOL installment;
@property (nonatomic, readwrite) NSNumber *installmentTerm;
@property (nonatomic, readwrite) NSString *token;
@property (nonatomic, readwrite) BOOL twoClick;
@property (nonatomic, readwrite) NSString *type;
@property (nonatomic, readwrite) NSString *cvv;
@property (nonatomic, readwrite) BOOL secure;
@property (nonatomic, readwrite) MTCreditCardPaymentFeature creditCardPaymentFeature;
@end

@implementation MTTokenizeRequest

- (instancetype)initWithCreditCard:(MTCreditCard *)creditCard grossAmount:(NSNumber *)grossAmount secure:(BOOL)secure {
    if (self = [super init]) {
        self.creditCard = creditCard;
        self.cvv = creditCard.cvv;
        self.grossAmount = grossAmount;
        self.creditCardPaymentFeature = MTCreditCardPaymentFeatureNormal;
        self.secure = secure;
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
        self.secure = YES;
        self.creditCardPaymentFeature = MTCreditCardPaymentFeatureTwoClick;
    }
    return self;
}

- (NSDictionary *)dictionaryValue {
    NSMutableDictionary *result = [NSMutableDictionary new];
    switch (_creditCardPaymentFeature) {
        case MTCreditCardPaymentFeatureTwoClick: {
            [result setDictionary:@{@"client_key":[CONFIG clientKey],
                                    @"card_cvv":[MTHelper nullifyIfNil:self.cvv],
                                    @"secure":_secure ? @"true":@"false",
                                    @"gross_amount":[MTHelper nullifyIfNil:self.grossAmount],
                                    @"two_click":@"true",
                                    @"token_id":[MTHelper nullifyIfNil:self.token]}];
            break;
        } case MTCreditCardPaymentFeatureNormal: {
            [result setDictionary:@{@"client_key":[CONFIG clientKey],
                                    @"card_number":self.creditCard.number,
                                    @"card_exp_month":self.creditCard.expiryMonth,
                                    @"card_exp_year":self.creditCard.expiryYear,
                                    @"card_type":[MTCreditCardHelper nameFromString: self.creditCard.number],
                                    @"card_cvv":[MTHelper nullifyIfNil:self.cvv],
                                    @"secure":_secure ? @"true":@"false",
                                    @"gross_amount":[MTHelper nullifyIfNil:self.grossAmount]}];
            break;
        } default: {
            [result setDictionary:@{@"client_key":[CONFIG clientKey],
                                    @"card_number":self.creditCard.number,
                                    @"card_exp_month":self.creditCard.expiryMonth,
                                    @"card_exp_year":self.creditCard.expiryYear,
                                    @"card_type":[MTCreditCardHelper nameFromString: self.creditCard.number],
                                    @"card_cvv":[MTHelper nullifyIfNil:self.cvv],
                                    @"bank":[MTHelper nullifyIfNil:self.bank],
                                    @"secure":_secure ? @"true":@"false",
                                    @"gross_amount":[MTHelper nullifyIfNil:self.grossAmount],
                                    @"installment":self.installment? @"true":@"false",
                                    @"installment_term":[MTHelper nullifyIfNil:self.installmentTerm],
                                    @"two_click":self.twoClick? @"true":@"false",
                                    @"type":[MTHelper nullifyIfNil:self.type]}];
            break;
        }
    }
    
    if ([CONFIG environment] == MTServerEnvironmentProduction) {
        [result setObject:@"migs" forKey:@"channel"];
    }
    
    return result;
}

@end
