//
//  MTPaymentCreditCard.m
//  iossdk-gojek
//
//  Created by Akbar Taufiq Herlangga on 3/10/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MidtransPaymentCreditCard.h"
#import "MidtransHelper.h"
#import "MidtransConfig.h"
#import "MidtransCreditCardConfig.h"

typedef NS_ENUM(NSUInteger, MidtransPaymentCreditCardType) {
    MidtransPaymentCreditCardTypeOneclick,
    MidtransPaymentCreditCardTypeTwoClicks,
    MidtransPaymentCreditCardTypeNormal
};

@interface MidtransPaymentCreditCard()
@property (nonatomic) NSString *_Nonnull creditCardToken;
@property (nonatomic) MidtransCustomerDetails *customerDetails;
@property (nonatomic) NSString *maskedCard;
@property (nonatomic, assign) MidtransPaymentCreditCardType paymentType;
@end

@implementation MidtransPaymentCreditCard

+ (instancetype)paymentOneClickWithMaskedCard:(NSString *)maskedCard customer:(MidtransCustomerDetails *)customer {
    MidtransPaymentCreditCard *payment = [MidtransPaymentCreditCard new];
    payment.customerDetails = customer;
    payment.maskedCard = maskedCard;
    payment.paymentType = MidtransPaymentCreditCardTypeOneclick;
    return payment;
}

+ (instancetype)paymentTwoClicksWithToken:(NSString *)token customer:(MidtransCustomerDetails *)customer {
    MidtransPaymentCreditCard *payment = [MidtransPaymentCreditCard new];
    payment.customerDetails = customer;
    payment.creditCardToken = token;
    payment.paymentType = MidtransPaymentCreditCardTypeTwoClicks;
    return payment;
}

+ (instancetype)paymentWithToken:(NSString *)token customer:(MidtransCustomerDetails *)customer {
    MidtransPaymentCreditCard *payment = [MidtransPaymentCreditCard new];
    payment.customerDetails = customer;
    payment.creditCardToken = token;
    payment.paymentType = MidtransPaymentCreditCardTypeNormal;
    return payment;
}

- (NSDictionary *)dictionaryValue {    
    return @{@"payment_type":MIDTRANS_PAYMENT_CREDIT_CARD,
             @"payment_params":[self paymentParameter],
             @"customer_details":@{@"email":self.customerDetails.email,
                                   @"phone":self.customerDetails.phone,
                                   @"full_name":self.customerDetails.firstName}};
}

- (NSDictionary *)paymentParameter {
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    
    switch (self.paymentType) {
        case MidtransPaymentCreditCardTypeNormal:
            [parameters setObject:self.creditCardToken forKey:@"card_token"];
            [parameters setObject:@([CC_CONFIG saveCardEnabled]) forKey:@"save_card"];
            break;
        case MidtransPaymentCreditCardTypeTwoClicks:
            [parameters setObject:self.creditCardToken forKey:@"card_token"];
            break;
        case MidtransPaymentCreditCardTypeOneclick:
            [parameters setObject:self.maskedCard forKey:@"masked_card"];
            break;
    }
    return parameters;
}
@end
