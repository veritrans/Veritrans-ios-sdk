//
//  MIDCreditCardCharge.m
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 11/12/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import "MIDCreditCardCharge.h"
#import "MIDCreditCardTokenize.h"
#import "MIDPaymentHelper.h"
#import "MIDCreditCardPayment.h"

@implementation MIDCreditCardCharge

+ (void)normalWithToken:(NSString *)snapToken
             cardNumber:(NSString *)cardNumber
                    cvv:(NSString *)cvv
            expireMonth:(NSString *)expireMonth
             expireYear:(NSString *)expireYear
                   bank:(NSString *_Nullable)bank
             completion:(void (^)(MIDCreditCardResult *_Nullable result, NSError *_Nullable error))completion {
    
    MIDCreditCardTokenize *tokenize = [MIDCreditCardTokenize new];
    tokenize.cardNumber = cardNumber;
    tokenize.cardCVV = cvv;
    tokenize.cardExpMonth = expireMonth;
    tokenize.cardExpYear = expireYear;
    
    [MIDPaymentHelper getTokenWithRequest:tokenize completion:^(NSString * _Nullable token, NSError * _Nullable error) {
        if (token) {
            MIDCreditCardPayment *payment = [MIDCreditCardPayment new];
            payment.creditCardToken = token;
            payment.saveCard = YES;
            
            [MIDPaymentHelper performPayment:payment
                                       token:snapToken
                                  completion:^(id _Nullable response, NSError *_Nullable error)
             {
                 if (response) {
                     MIDCreditCardResult *result = [[MIDCreditCardResult alloc] initWithDictionary:response];
                     completion(result, error);
                 } else {
                     completion(nil, error);
                 }
             }];
            
        } else {
            completion(nil, error);
        }
        
    }];
}

@end
