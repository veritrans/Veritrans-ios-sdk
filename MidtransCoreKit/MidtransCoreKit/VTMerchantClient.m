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

    [[VTNetworking sharedInstance] postToURL:URL parameters:[transaction dictionaryValue] callback:^(id response, NSError *error) {
        [VTHelper handleResponse:response completion:^(id response, NSError *error) {
            if (completion) completion(response, error);
        }];
    }];

}

@end
