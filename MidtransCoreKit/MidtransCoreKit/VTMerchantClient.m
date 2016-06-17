//
//  VTMerchantClient.m
//  iossdk-gojek
//
//  Created by Akbar Taufiq Herlangga on 3/10/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTMerchantClient.h"
#import "VTConfig.h"
#import "VTNetworking.h"
#import "VTHelper.h"
#import "VTPaymentWebController.h"

@implementation VTMerchantClient

+ (id)sharedClient {
    // Idea stolen from http://www.galloway.me.uk/tutorials/singleton-classes/
    static VTMerchantClient *instance = nil;
    @synchronized(self) {
        if (instance == nil) {
            instance = [[self alloc] init];
        }
    }
    
    return instance;
}

- (void)performTransaction:(VTTransaction *)transaction completion:(void(^)(VTTransactionResult *result, NSError *error))completion {
    NSString *URL = [NSString stringWithFormat:@"%@/%@", [CONFIG merchantServerURL], @"charge"];
    
    NSMutableDictionary *headers = [[NSMutableDictionary alloc] init];
    [headers addEntriesFromDictionary:[CONFIG merchantClientData]];
    
    [[VTNetworking sharedInstance] postToURL:URL header:headers parameters:[transaction dictionaryValue] callback:^(id response, NSError *error) {
        
        if (response) {
            VTTransactionResult *chargeResult = [[VTTransactionResult alloc] initWithTransactionResponse:response];
            NSString *paymentType = response[@"payment_type"];
            
            if ([self isWebPaymentType:paymentType]) {
                
                NSURL *redirectURL = [NSURL URLWithString:response[@"redirect_url"]];
                VTPaymentWebController *vc = [[VTPaymentWebController alloc] initWithRedirectURL:redirectURL paymentType:paymentType];
                [vc showPageWithCallback:^(NSError * _Nullable error) {
                    if (error) {
                        if (completion) completion(nil, error);
                    } else {
                        if (completion) completion(chargeResult, nil);
                    }
                }];
                
            } else if ([paymentType isEqualToString:VT_PAYMENT_CREDIT_CARD]) {
                
                BOOL isSavedToken = response[@"saved_token_id"] != nil;
                if (isSavedToken) {
                    VTMaskedCreditCard *savedCard = [[VTMaskedCreditCard alloc] initWithData:response];
                    [self saveRegisteredCard:savedCard completion:^(id result, NSError *error) {
                        if (completion) completion(chargeResult, error);
                    }];
                }
                
            } else {
                if (completion) completion(chargeResult, error);
            }
        } else {
            if (completion) completion(nil, error);
        }
    }];
}

- (void)saveRegisteredCard:(VTMaskedCreditCard *)savedCard completion:(void(^)(id result, NSError *error))completion {
    NSString *URL = [NSString stringWithFormat:@"%@/%@", [CONFIG merchantServerURL], @"card/register"];
    [[VTNetworking sharedInstance] postToURL:URL header:[CONFIG merchantClientData] parameters:savedCard.dictionaryValue callback:completion];
}

- (void)fetchMaskedCardsWithCompletion:(void(^)(NSArray *maskedCards, NSError *error))completion {
    NSString *URL = [NSString stringWithFormat:@"%@/%@", [CONFIG merchantServerURL], @"card"];
    [[VTNetworking sharedInstance] getFromURL:URL header:[CONFIG merchantClientData]  parameters:nil callback:^(id response, NSError *error) {
        
        NSMutableArray *result;
        if (response) {
            result = [NSMutableArray new];
            NSArray *rawCards = response[@"data"];
            for (id rawCard in rawCards) {
                VTMaskedCreditCard *card = [[VTMaskedCreditCard alloc] initWithData:rawCard];
                [result addObject:card];
            }
        }
        if (completion) completion(result, error);
        
    }];
}

- (void)deleteMaskedCard:(VTMaskedCreditCard *)maskedCard completion:(void(^)(BOOL success, NSError *error))completion {
    NSString *URL = [NSString stringWithFormat:@"%@/%@/%@", [CONFIG merchantServerURL], @"card", maskedCard.savedTokenId];
    [[VTNetworking sharedInstance] deleteFromURL:URL header:[CONFIG merchantClientData] parameters:nil callback:^(id response, NSError *error) {
        if (response) {
            if (completion) completion(true, error);
        } else {
            if (completion) completion(false, error);
        }
    }];
}

- (void)fetchMerchantAuthDataWithCompletion:(void(^)(id response, NSError *error))completion {
    NSString *URL = [NSString stringWithFormat:@"%@/auth", [CONFIG merchantServerURL]];
    [[VTNetworking sharedInstance] postToURL:URL parameters:nil callback:completion];
}

#pragma mark - Helper

- (BOOL)isWebPaymentType:(NSString *)paymentType {
    return [paymentType isEqualToString:VT_PAYMENT_CIMB_CLICKS] ||
    [paymentType isEqualToString:VT_PAYMENT_BCA_KLIKPAY] ||
    [paymentType isEqualToString:VT_PAYMENT_MANDIRI_ECASH];
}

@end
