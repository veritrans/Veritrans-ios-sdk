//
//  VTClient.m
//  iossdk-gojek
//
//  Created by Akbar Taufiq Herlangga on 3/8/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTClient.h"
#import "VTConfig.h"
#import "VTNetworking.h"
#import "VTHelper.h"
#import "VTPrivateConfig.h"
#import "VTCreditCardHelper.h"

@interface VTClient ()

@end

@implementation VTClient

+ (id)sharedClient {
    static VTClient *instance = nil;
    @synchronized(self) {
        if (instance == nil) {
            instance = [[self alloc] init];
        }
    }
    
    return instance;
}

- (void)generateToken:(VTTokenizeRequest *_Nonnull)tokenizeRequest
           completion:(void (^_Nullable)(NSString *_Nullable token, NSString *_Nullable redirectURL, NSError *_Nullable error))completion {
    NSString *URL = [NSString stringWithFormat:@"%@/%@", [PRIVATECONFIG baseUrl], @"token"];
    
    [[VTNetworking sharedInstance] getFromURL:URL parameters:[tokenizeRequest dictionaryValue] callback:^(id response, NSError *error) {
        if (error) {
            if (completion) completion(nil, nil, error);
        } else {
            if (completion) completion(response[@"token_id"], response[@"redirect_url"], nil);
        }
    }];
}

- (void)registerCreditCard:(VTCreditCard *_Nonnull)creditCard
                completion:(void (^_Nullable)(VTMaskedCreditCard *_Nullable maskedCreditCard, NSError *_Nullable error))completion {
    NSError *error = nil;
    if ([creditCard isValidCreditCard:&error] == NO) {
        if (completion) completion(nil, error);
        return;
    }
    NSString *URL = [NSString stringWithFormat:@"%@/%@", [PRIVATECONFIG baseUrl], @"card/register"];
    [[VTNetworking sharedInstance] getFromURL:URL parameters:[creditCard dictionaryValue] callback:^(id response, NSError *error) {
        if (response) {
            VTMaskedCreditCard *maskedCreditCard = [[VTMaskedCreditCard alloc] initWithData:response];
            if (completion) completion(maskedCreditCard, error);
        } else {
            if (completion) completion(nil, error);
        }
    }];
}

@end
