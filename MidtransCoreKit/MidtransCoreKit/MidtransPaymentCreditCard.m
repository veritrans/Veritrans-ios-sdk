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
@property (nonatomic) NSString *_Nullable installment;
@property (nonatomic) NSString *maskedCard;
@property (nonatomic) NSString *point;
@property (nonatomic) BOOL saveCard;
@end

@implementation MidtransPaymentCreditCard

+ (instancetype)modelWithToken:(NSString *)token customer:(MidtransCustomerDetails *)customer saveCard:(BOOL)saveCard installment:(NSString *)installment {
    MidtransPaymentCreditCard *payment = [MidtransPaymentCreditCard new];
    if (installment !=nil) {
        payment.installment = installment;
    }
    payment.customerDetails = customer;
    payment.creditCardToken = token;
    payment.saveCard = saveCard;
    return payment;
}

+ (instancetype)modelWithMaskedCard:(NSString *)maskedCard customer:(MidtransCustomerDetails *)customer saveCard:(BOOL)saveCard installment:(NSString *)installment {
    MidtransPaymentCreditCard *payment = [MidtransPaymentCreditCard new];
    if (installment !=nil) {
        payment.installment = installment;
    }
    
    payment.customerDetails = customer;
    payment.maskedCard = maskedCard;
    payment.saveCard = saveCard;
    return payment;
}

+ (instancetype)modelWithToken:(NSString *)token customer:(MidtransCustomerDetails *)customer saveCard:(BOOL)saveCard point:(NSString *)point {
    MidtransPaymentCreditCard *payment = [MidtransPaymentCreditCard new];
    payment.customerDetails = customer;
    payment.creditCardToken = token;
    payment.saveCard = saveCard;
    payment.point = point;
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
    NSMutableDictionary *value = [NSMutableDictionary new];
    value[@"payment_type"] = MIDTRANS_PAYMENT_CREDIT_CARD;
    value[@"payment_params"] = [self paymentParameter];
    value[@"customer_details"] = @{@"email":self.customerDetails.email,
                                   @"phone":self.customerDetails.phone,
                                   @"full_name":self.customerDetails.firstName};
    if (self.discountToken) {
        value[@"discount_token"] = self.discountToken;
    }
    return value;
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
    if (self.point) {
         [parameters setObject:self.point forKey:@"point"];
    }
    if (self.installment) {
        [parameters setObject:self.installment forKey:@"installment"];
    }
    
    return parameters;
}
@end
