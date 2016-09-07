//
//  VTClient.m
//  iossdk-gojek
//
//  Created by Akbar Taufiq Herlangga on 3/8/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MTClient.h"
#import "MTConfig.h"
#import "MTNetworking.h"
#import "MTTrackingManager.h"
#import "VTHelper.h"
#import "MTPrivateConfig.h"
#import "MTCreditCardHelper.h"
#import "MT3DSController.h"

NSString *const GENERATE_TOKEN_URL = @"token";
NSString *const REGISTER_CARD_URL = @"card/register";

@interface MTClient ()

@end

@implementation MTClient

+ (id)sharedClient {
    static MTClient *instance = nil;
    @synchronized(self) {
        if (instance == nil) {
            instance = [[self alloc] init];
        }
    }
    
    return instance;
}

- (void)generateToken:(VTTokenizeRequest *_Nonnull)tokenizeRequest
           completion:(void (^_Nullable)(NSString *_Nullable token, NSError *_Nullable error))completion {
    NSString *URL = [NSString stringWithFormat:@"%@/%@", [PRIVATECONFIG baseUrl], GENERATE_TOKEN_URL];
    
    [[MTNetworking sharedInstance] getFromURL:URL parameters:[tokenizeRequest dictionaryValue] callback:^(id response, NSError *error) {
        if (error) {
            [[MTTrackingManager sharedInstance] trackAppFailGenerateToken:nil
                                                           secureProtocol:NO
                                                       withPaymentFeature:0 paymentMethod:@"credit card" value:nil];
            if (completion) completion(nil, error);
        } else {
            NSString *redirectURL = response[@"redirect_url"];
            NSString *token = response[@"token_id"];
            if (redirectURL) {
                [[MTTrackingManager sharedInstance] trackAppSuccessGenerateToken:token
                                                                  secureProtocol:YES
                                                              withPaymentFeature:0 paymentMethod:@"credit card" value:nil];
                MT3DSController *secureController = [[MT3DSController alloc] initWithToken:token
                                                                                 secureURL:[NSURL URLWithString:redirectURL]];
                [secureController showWithCompletion:^(NSError *error) {
                    if (error) {
                        if (completion) completion(nil, error);
                    } else {
                        if (completion) completion(token, error);
                    }
                }];
            } else {
                [[MTTrackingManager sharedInstance] trackAppSuccessGenerateToken:token
                                                                  secureProtocol:NO
                                                              withPaymentFeature:0 paymentMethod:@"credit card" value:nil];
                if (completion) completion(token, nil);
            }
        }
    }];
}

- (void)registerCreditCard:(MTCreditCard *_Nonnull)creditCard
                completion:(void (^_Nullable)(MTMaskedCreditCard *_Nullable maskedCreditCard, NSError *_Nullable error))completion {
    NSError *error = nil;
    if ([creditCard isValidCreditCard:&error] == NO) {
        if (completion) completion(nil, error);
        return;
    }
    NSString *URL = [NSString stringWithFormat:@"%@/%@", [PRIVATECONFIG baseUrl], REGISTER_CARD_URL];
    [[MTNetworking sharedInstance] getFromURL:URL parameters:[creditCard dictionaryValue] callback:^(id response, NSError *error) {
        if (response) {
            MTMaskedCreditCard *maskedCreditCard = [[MTMaskedCreditCard alloc] initWithData:response];
            if (completion) completion(maskedCreditCard, error);
        } else {
            if (completion) completion(nil, error);
        }
    }];
}

@end
