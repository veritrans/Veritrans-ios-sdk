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
@property (nonatomic) BOOL saveCard;
@end

@implementation MidtransPaymentCreditCard

+ (instancetype)modelWithToken:(NSString *)token customer:(MidtransCustomerDetails *)customer saveCard:(BOOL)saveCard {
    MidtransPaymentCreditCard *payment = [MidtransPaymentCreditCard new];
    payment.customerDetails = customer;
    payment.creditCardToken = token;
    payment.saveCard = saveCard;
    return payment;
}

+ (instancetype)modelWithMaskedCard:(NSString *)maskedCard customer:(MidtransCustomerDetails *)customer saveCard:(BOOL)saveCard {
    MidtransPaymentCreditCard *payment = [MidtransPaymentCreditCard new];
    payment.customerDetails = customer;
    payment.maskedCard = maskedCard;
    payment.saveCard = saveCard;
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
    if (self.maskedCard) {
        [parameters setObject:self.maskedCard forKey:@"masked_card"];
    }
    else {
        [parameters setObject:self.creditCardToken forKey:@"card_token"];
        [parameters setObject:@(self.saveCard) forKey:@"save_card"];
    }
    return parameters;
}
@end
