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
#import "MidtransTrackingManager.h"
#import "MidtransCreditCardHelper.h"
#import "MidtransCreditCardPaymentFeature.h"
#import "MidtransCreditCardConfig.h"

@interface MidtransTokenizeRequest()
@property (nonatomic, readwrite) MidtransCreditCard *creditCard;
@property (nonatomic, readwrite) NSNumber *grossAmount;
@property (nonatomic, readwrite) BOOL installment;
@property (nonatomic, readwrite) NSNumber *installmentTerm;
@property (nonatomic, readwrite) NSString *token;
@property (nonatomic, readwrite) BOOL twoClick;
@property (nonatomic, readwrite) NSString *type;
@property (nonatomic, readwrite) NSString *cvv;
@property (nonatomic, readwrite) BOOL secure;
@property (nonatomic, readwrite) MidtransCreditCardPaymentFeature creditCardPaymentFeature;
@end

@implementation MidtransTokenizeRequest

- (instancetype)initWithCreditCard:(MidtransCreditCard *)creditCard
                       grossAmount:(NSNumber *)grossAmount
                            secure:(BOOL)secure {
    if (self = [super init]) {
        self.creditCard = creditCard;
        self.cvv = creditCard.cvv;
        self.grossAmount = grossAmount;
        self.creditCardPaymentFeature = MidtransCreditCardPaymentFeatureNormal;
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
        self.creditCardPaymentFeature = MidtransCreditCardPaymentFeatureTwoClick;
    }
    return self;
}

- (NSDictionary *)dictionaryValue {
    NSMutableDictionary *result = [NSMutableDictionary new];
    switch (_creditCardPaymentFeature) {
        case MidtransCreditCardPaymentFeatureTwoClick: {
            [result setDictionary:@{@"client_key":[CONFIG clientKey],
                                    @"card_cvv":[MidtransHelper nullifyIfNil:self.cvv],
                                    @"secure":_secure ? @"true":@"false",
                                    @"gross_amount":[MidtransHelper nullifyIfNil:self.grossAmount],
                                    @"two_click":@"true",
                                    @"token_id":[MidtransHelper nullifyIfNil:self.token]}];
            break;
        } case MidtransCreditCardPaymentFeatureNormal: {
            [result setDictionary:@{@"client_key":[CONFIG clientKey],
                                    @"card_number":self.creditCard.number,
                                    @"card_exp_month":self.creditCard.expiryMonth,
                                    @"card_exp_year":self.creditCard.expiryYear,
                                    @"card_type":[MidtransCreditCardHelper nameFromString: self.creditCard.number],
                                    @"card_cvv":[MidtransHelper nullifyIfNil:self.cvv],
                                    @"secure":_secure ? @"true":@"false",
                                    @"gross_amount":[MidtransHelper nullifyIfNil:self.grossAmount]}];
            break;
        } default: {
            [result setDictionary:@{@"client_key":[CONFIG clientKey],
                                    @"card_number":self.creditCard.number,
                                    @"card_exp_month":self.creditCard.expiryMonth,
                                    @"card_exp_year":self.creditCard.expiryYear,
                                    @"card_type":[MidtransCreditCardHelper nameFromString: self.creditCard.number],
                                    @"card_cvv":[MidtransHelper nullifyIfNil:self.cvv],
                                    @"bank":[MidtransHelper nullifyIfNil:self.bank],
                                    @"secure":_secure ? @"true":@"false",
                                    @"gross_amount":[MidtransHelper nullifyIfNil:self.grossAmount],
                                    @"installment":self.installment? @"true":@"false",
                                    @"installment_term":[MidtransHelper nullifyIfNil:self.installmentTerm],
                                    @"two_click":self.twoClick? @"true":@"false",
                                    @"type":[MidtransHelper nullifyIfNil:self.type]}];
            break;
        }
    }
    
    if (CC_CONFIG.bank)
        [result setObject:CC_CONFIG.bank forKey:@"bank"];
    
    if ([CONFIG environment] == MidtransServerEnvironmentProduction) {
        [result setObject:@"migs" forKey:@"channel"];
    }
    
    return result;
}

@end
