//
//  MIDCreditCardTokenizer.m
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 26/12/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import "MIDCreditCardTokenizer.h"
#import "MIDPaymentHelper.h"
#import "MIDCreditCardTokenize.h"

@implementation MIDCreditCardTokenizer

+ (void)tokenizeCardNumber:(NSString *)cardNumber
                       cvv:(NSString *)cvv
               expireMonth:(NSString *)expireMonth
                expireYear:(NSString *)expireYear
                    config:(MIDTokenizeConfig *_Nullable)config
                completion:(void (^)(MIDTokenizeResponse *_Nullable token, NSError *_Nullable error))completion {
    
    MIDCreditCardTokenize *obj = [MIDCreditCardTokenize new];
    obj.number = cardNumber;
    obj.cvv = cvv;
    obj.expMonth = expireMonth;
    obj.expYear = expireYear;
    obj.config = config;
    
    [MIDPaymentHelper getTokenWithRequest:obj completion:^(MIDTokenizeResponse *_Nullable token, NSError * _Nullable error) {
        completion(token, error);
    }];
}

+ (void)tokenizeCardToken:(NSString *)cardToken
                      cvv:(NSString *)cvv
                   config:(MIDTokenizeConfig *)config
               completion:(void (^)(MIDTokenizeResponse *_Nullable token, NSError *_Nullable error))completion {
    
    MIDCreditCardTokenize *obj = [MIDCreditCardTokenize new];
    obj.tokenID = cardToken;
    obj.cvv = cvv;
    obj.config = config;
    
    [MIDPaymentHelper getTokenWithRequest:obj completion:^(MIDTokenizeResponse *_Nullable token, NSError * _Nullable error) {
        completion(token, error);
    }];
}

@end
