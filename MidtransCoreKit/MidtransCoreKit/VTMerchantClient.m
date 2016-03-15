//
//  VTMerchantClient.m
//  MidtransCoreKit
//
//  Created by Akbar Taufiq Herlangga on 3/10/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTMerchantClient.h"
#import "VTConfig.h"
#import "VTNetworking.h"
#import "VTHelper.h"

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

- (void)performCreditCardTransaction:(VTCTransactionData *)transaction completion:(void(^)(id response, NSError *error))completion {
    NSString *URL = [NSString stringWithFormat:@"%@/%@", [CONFIG merchantServerURL], @"charge"];
    
    [[VTNetworking sharedInstance] postToURL:URL header:[[CONFIG merchantAuth] dictinaryValue] parameters:[transaction dictionaryValue] callback:^(id response, NSError *error) {
        [VTHelper handleResponse:response completion:completion];
    }];
}

- (void)saveRegisteredCard:(id)savedCard completion:(void(^)(id response, NSError *error))completion {
    NSString *URL = [NSString stringWithFormat:@"%@/%@", [CONFIG merchantServerURL], @"card/register"];
    [[VTNetworking sharedInstance] postToURL:URL header:[[CONFIG merchantAuth] dictinaryValue] parameters:savedCard callback:^(id response, NSError *error) {
        [VTHelper handleResponse:response completion:completion];
    }];
}

- (void)fetchMaskedCardsWithCompletion:(void(^)(NSArray *maskedCards, NSError *error))completion {
    NSString *URL = [NSString stringWithFormat:@"%@/%@", [CONFIG merchantServerURL], @"card"];
    [[VTNetworking sharedInstance] getFromURL:URL header:[[CONFIG merchantAuth] dictinaryValue] parameters:nil callback:^(id response, NSError *error) {
        [VTHelper handleResponse:response completion:^(id response, NSError *error) {
            
            NSMutableArray *result;
            if (response) {
                result = [NSMutableArray new];
                NSArray *rawCards = response[@"data"];
                for (id rawCard in rawCards) {
                    VTMaskedCreditCard *card = [VTMaskedCreditCard maskedCardFromData:rawCard];
                    [result addObject:card];
                }
            }
            if (completion) completion(result, error);
            
        }];
    }];
}

- (void)fetchMerchantAuthDataWithCompletion:(void(^)(id response, NSError *error))completion {
    NSString *URL = [NSString stringWithFormat:@"%@/auth", [CONFIG merchantServerURL]];
    [[VTNetworking sharedInstance] postToURL:URL parameters:nil callback:completion];
}

@end
