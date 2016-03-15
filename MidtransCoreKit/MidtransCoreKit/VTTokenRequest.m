//
//  VTTokenRequest.m
//  MidtransCoreKit
//
//  Created by Akbar Taufiq Herlangga on 3/10/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTTokenRequest.h"
#import "VTConfig.h"
#import "VTHelper.h"

@interface VTTokenRequest()
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
@end

@implementation VTTokenRequest

+ (instancetype)tokenForNormalTransactionWithCreditCard:(VTCreditCard *)creditCard {
    VTTokenRequest *req = [VTTokenRequest new];
    req.creditCard = creditCard;
    return req;
}

+ (instancetype)tokenForTwoClickTransactionWithToken:(NSString *)token
                                                 cvv:(NSString *)cvv
                                              secure:(BOOL)secure
                                         grossAmount:(NSNumber *)grossAmount {
    VTTokenRequest *req = [VTTokenRequest new];
    req.grossAmount = grossAmount;
    req.token = token;
    req.cvv = cvv;
    req.secure = secure;
    return req;
}

- (NSDictionary *)dictionaryValue {
    switch ([CONFIG creditCardFeature]) {
        case VTCreditCardFeatureTwoClick:
            return @{@"client_key":[CONFIG clientKey],
                     @"card_cvv":[VTHelper nullifyIfNil:self.cvv],
                     @"secure":_secure ? @"true":@"false",
                     @"gross_amount":[VTHelper nullifyIfNil:self.grossAmount],
                     @"two_click":@"true",
                     @"token_id":[VTHelper nullifyIfNil:self.token]
                     };
        case VTCreditCardFeatureNormal:
            return @{@"client_key":[CONFIG clientKey],
                     @"card_number":self.creditCard.number,
                     @"card_exp_month":self.creditCard.expiryMonth,
                     @"card_exp_year":self.creditCard.expiryYear,
                     @"card_type":[VTCreditCard typeStringWithNumber:self.creditCard.number],
                     @"card_cvv":[VTHelper nullifyIfNil:self.cvv],
                     @"secure":_secure ? @"true":@"false",
                     @"gross_amount":[VTHelper nullifyIfNil:self.grossAmount]
                     };
        default:
            return @{@"client_key":[CONFIG clientKey],
                     @"card_number":self.creditCard.number,
                     @"card_exp_month":self.creditCard.expiryMonth,
                     @"card_exp_year":self.creditCard.expiryYear,
                     @"card_type":[VTCreditCard typeStringWithNumber:self.creditCard.number],
                     @"card_cvv":[VTHelper nullifyIfNil:self.cvv],
                     @"bank":[VTHelper nullifyIfNil:self.bank],
                     @"secure":_secure ? @"true":@"false",
                     @"gross_amount":[VTHelper nullifyIfNil:self.grossAmount],
                     @"installment":self.installment? @"true":@"false",
                     @"installment_term":[VTHelper nullifyIfNil:self.installmentTerm],
                     @"two_click":self.twoClick? @"true":@"false",
                     @"type":[VTHelper nullifyIfNil:self.type],
                     @"token_id":[VTHelper nullifyIfNil:self.token]
                     };
    }
}

@end
