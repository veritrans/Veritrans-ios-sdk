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
#import "MIDNetworkService.h"
#import "MIDNetwork.h"
#import "MIDNetworkHelper.h"
#import "MIDVendor.h"

@implementation MIDCreditCardCharge

+ (void)chargeWithToken:(NSString *)snapToken
              cardToken:(NSString *)cardToken
                   save:(BOOL)save
            installment:(MIDChargeInstallment *_Nullable)installment
                  point:(NSNumber *_Nullable)point
             completion:(void (^_Nullable)(MIDCreditCardResult *_Nullable result, NSError *_Nullable error))completion {
    
    MIDCreditCardPayment *payment = [MIDCreditCardPayment new];
    payment.creditCardToken = cardToken;
    payment.saveCard = save;
    payment.installment = installment.value;
    payment.point = point;
    
    [MIDPaymentHelper performPayment:payment token:snapToken completion:^(id  _Nullable response, NSError * _Nullable error) {
        if (response) {
            MIDCreditCardResult *result = [[MIDCreditCardResult alloc] initWithDictionary:response];
            completion(result, nil);
        } else {
            completion(nil, error);
        }
    }];
}

+ (void)getPointWithToken:(NSString *)snapToken
                cardToken:(NSString *)cardToken
               completion:(void (^_Nullable)(MIDPointResponse *_Nullable result, NSError *_Nullable error))completion {
    
    NSString *path = [NSString stringWithFormat:@"/transactions/%@/point_inquiry/%@",snapToken, cardToken];
    MIDNetworkService *service = [[MIDNetworkService alloc] initWithBaseURL:[MIDVendor shared].snapURL
                                                                       path:path
                                                                     method:MIDNetworkMethodGET
                                                                 parameters:nil];
    [[MIDNetwork shared] request:service completion:^(id _Nullable response, NSError * _Nullable error) {
        if (response) {
            MIDPointResponse *result = [[MIDPointResponse alloc] initWithDictionary:response];
            completion(result, nil);
        } else {
            completion(nil, error);
        }
    }];
}

@end
