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

@interface VTClient ()

@end

@implementation VTClient

+ (id)sharedClient {
    // Idea stolen from http://www.galloway.me.uk/tutorials/singleton-classes/
    static VTClient *instance = nil;
    @synchronized(self) {
        if (instance == nil) {
            instance = [[self alloc] init];
        }
    }
    
    return instance;
}

- (void)generateToken:(VTTokenizeRequest *)tokenizeRequest
           completion:(void (^)(NSString *token, NSString *redirectURL, NSError *error))completion {
    NSString *URL = [NSString stringWithFormat:@"%@/%@", [CONFIG baseUrl], @"token"];
    
    [[VTNetworking sharedInstance] getFromURL:URL parameters:[tokenizeRequest dictionaryValue] callback:^(id response, NSError *error) {
        if (error) {
            if (completion) completion(nil, nil, error);
        } else {
            if (completion) completion(response[@"token_id"], response[@"redirect_url"], nil);
        }
    }];
}

- (void)registerCreditCard:(VTCreditCard *)creditCard
                completion:(void (^)(VTMaskedCreditCard *maskedCreditCard, NSError *error))completion {
    NSString *URL = [NSString stringWithFormat:@"%@/%@", [CONFIG baseUrl], @"card/register"];
    NSDictionary *param = @{@"client_key":[CONFIG clientKey],
                            @"card_number":creditCard.number,
                            @"card_exp_month":creditCard.expiryMonth,
                            @"card_exp_year":creditCard.expiryYear};
    
    [[VTNetworking sharedInstance] getFromURL:URL parameters:param callback:^(id response, NSError *error) {
        if (response) {
            VTMaskedCreditCard *maskedCreditCard = [[VTMaskedCreditCard alloc] initWithData:response];
            if (completion) completion(maskedCreditCard, error);
        } else {
            if (completion) completion(nil, error);
        }
    }];
}

@end
