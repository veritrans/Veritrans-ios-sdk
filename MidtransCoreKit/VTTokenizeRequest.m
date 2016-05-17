//
//  VTTokenizeRequest.m
//  iossdk-gojek
//
//  Created by Akbar Taufiq Herlangga on 3/10/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTTokenizeRequest.h"
#import "VTConfig.h"
#import "VTHelper.h"
#import "VTCreditCardHelper.h"
#import "VTCreditCardPaymentFeature.h"

@interface VTTokenizeRequest()
@property (nonatomic, readwrite) VTCreditCard *creditCard;
@property (nonatomic, readwrite) NSString *bank;
@property (nonatomic, readwrite) NSNumber *grossAmount;
@property (nonatomic, readwrite) BOOL installment;
@property (nonatomic, readwrite) NSNumber *installmentTerm;
@property (nonatomic, readwrite) NSString *token;
@property (nonatomic, readwrite) BOOL twoClick;
@property (nonatomic, readwrite) NSString *type;
@property (nonatomic, readwrite) NSString *cvv;
@property (nonatomic, readwrite) BOOL secure;
@property (nonatomic, readwrite) VTCreditCardPaymentFeature creditCardPaymentFeature;
@end

@implementation VTTokenizeRequest

+ (instancetype)tokenForNormalTransactionWithCreditCard:(VTCreditCard *)creditCard grossAmount:(NSNumber *)grossAmount {
    VTTokenizeRequest *req = [VTTokenizeRequest new];
    req.creditCard = creditCard;
    req.cvv = creditCard.cvv;
    req.grossAmount = grossAmount;
    req.creditCardPaymentFeature = VTCreditCardPaymentFeatureNormal;
    return req;
}

+ (instancetype)tokenForTwoClickTransactionWithToken:(NSString *)token
                                                 cvv:(NSString *)cvv
                                              secure:(BOOL)secure
                                         grossAmount:(NSNumber *)grossAmount {
    VTTokenizeRequest *req = [VTTokenizeRequest new];
    req.grossAmount = grossAmount;
    req.token = token;
    req.cvv = cvv;
    req.secure = secure;
    req.creditCardPaymentFeature = VTCreditCardPaymentFeatureTwoClick;
    return req;
}

+ (instancetype)tokenFor3DSecureTransactionWithCreditCard:(VTCreditCard *)creditCard bank:(NSString *)bank grossAmount:(NSNumber *)grossAmount {
    VTTokenizeRequest *req = [VTTokenizeRequest new];
    req.creditCard = creditCard;
    req.cvv = creditCard.cvv;
    req.grossAmount = grossAmount;
    req.secure = YES;
    req.bank = bank;
    return req;
}

- (NSDictionary *)dictionaryValue {
    NSMutableDictionary *result = [NSMutableDictionary new];
    switch (_creditCardPaymentFeature) {
        case VTCreditCardPaymentFeatureTwoClick:
            [result setDictionary:@{@"client_key":[CONFIG clientKey],
                                    @"card_cvv":[VTHelper nullifyIfNil:self.cvv],
                                    @"secure":_secure ? @"true":@"false",
                                    @"gross_amount":[VTHelper nullifyIfNil:self.grossAmount],
                                    @"two_click":@"true",
                                    @"token_id":[VTHelper nullifyIfNil:self.token]}];
        case VTCreditCardPaymentFeatureNormal:
            [result setDictionary:@{@"client_key":[CONFIG clientKey],
                                    @"card_number":self.creditCard.number,
                                    @"card_exp_month":self.creditCard.expiryMonth,
                                    @"card_exp_year":self.creditCard.expiryYear,
                                    @"card_type":[VTCreditCardHelper typeStringWithNumber:self.creditCard.number],
                                    @"card_cvv":[VTHelper nullifyIfNil:self.cvv],
                                    @"secure":_secure ? @"true":@"false",
                                    @"gross_amount":[VTHelper nullifyIfNil:self.grossAmount]}];
        default:
            [result setDictionary:@{@"client_key":[CONFIG clientKey],
                                    @"card_number":self.creditCard.number,
                                    @"card_exp_month":self.creditCard.expiryMonth,
                                    @"card_exp_year":self.creditCard.expiryYear,
                                    @"card_type":[VTCreditCardHelper typeStringWithNumber:self.creditCard.number],
                                    @"card_cvv":[VTHelper nullifyIfNil:self.cvv],
                                    @"bank":[VTHelper nullifyIfNil:self.bank],
                                    @"secure":_secure ? @"true":@"false",
                                    @"gross_amount":[VTHelper nullifyIfNil:self.grossAmount],
                                    @"installment":self.installment? @"true":@"false",
                                    @"installment_term":[VTHelper nullifyIfNil:self.installmentTerm],
                                    @"two_click":self.twoClick? @"true":@"false",
                                    @"type":[VTHelper nullifyIfNil:self.type]}];
    }
    
    if ([CONFIG environment] == VTServerEnvironmentProduction) {
        [result setObject:@"migs" forKey:@"channel"];
    }
    
    return result;
}

@end
