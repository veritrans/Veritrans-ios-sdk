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

- (instancetype)initWithCreditCard:(VTCreditCard *)creditCard grossAmount:(NSNumber *)grossAmount secure:(BOOL)secure
{
    if (self = [super init]) {
        self.creditCard = creditCard;
        self.cvv = creditCard.cvv;
        self.grossAmount = grossAmount;
        self.creditCardPaymentFeature = VTCreditCardPaymentFeatureNormal;
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
        self.creditCardPaymentFeature = VTCreditCardPaymentFeatureTwoClick;
    }
    return self;
}

- (NSDictionary *)dictionaryValue {
    NSMutableDictionary *result = [NSMutableDictionary new];
    switch (_creditCardPaymentFeature) {
        case VTCreditCardPaymentFeatureTwoClick: {
            [result setDictionary:@{@"client_key":[CONFIG clientKey],
                                    @"card_cvv":[VTHelper nullifyIfNil:self.cvv],
                                    @"secure":_secure ? @"true":@"false",
                                    @"gross_amount":[VTHelper nullifyIfNil:self.grossAmount],
                                    @"two_click":@"true",
                                    @"token_id":[VTHelper nullifyIfNil:self.token]}];
            break;
        } case VTCreditCardPaymentFeatureNormal: {
            [result setDictionary:@{@"client_key":[CONFIG clientKey],
                                    @"card_number":self.creditCard.number,
                                    @"card_exp_month":self.creditCard.expiryMonth,
                                    @"card_exp_year":self.creditCard.expiryYear,
                                    @"card_type":[VTCreditCardHelper typeStringWithNumber:self.creditCard.number],
                                    @"card_cvv":[VTHelper nullifyIfNil:self.cvv],
                                    @"secure":_secure ? @"true":@"false",
                                    @"gross_amount":[VTHelper nullifyIfNil:self.grossAmount]}];
            break;
        } default: {
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
            break;
        }
    }
    
    if ([CONFIG environment] == VTServerEnvironmentProduction) {
        [result setObject:@"migs" forKey:@"channel"];
    }
    
    return result;
}

@end
