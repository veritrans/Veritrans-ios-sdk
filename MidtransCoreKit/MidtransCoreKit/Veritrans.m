//
//  Veritrans.m
//  MidtransCoreKit
//
//  Created by Akbar Taufiq Herlangga on 3/3/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "Veritrans.h"
#import "VTConfig.h"
#import "VTPaymentDelegate.h"
#import "VTNetworking.h"

@implementation Veritrans

+ (id)sharedInstance {
    // Idea stolen from http://www.galloway.me.uk/tutorials/singleton-classes/
    static Veritrans *instance = nil;
    @synchronized(self) {
        if (instance == nil) {
            instance = [[self alloc] init];
        }
    }
    
    return instance;
}

- (void)payUsingPermataBankForTransaction:(VTCTransactionData *)transactionData {
    NSString *url = [NSString stringWithFormat:@"%@/%@", [[VTConfig sharedInstance] baseUrl], @"charge"];
    [[VTNetworking sharedInstance] postToURL:url parameters:[transactionData dictionaryValue] callback:^(id response, NSError *error) {
        if (self.delegate) {
            if (error) {
                [self.delegate paymentFailed];
            } else {
                [self.delegate paymentSuccessfullyCompleted];
            }
        }
    }];
}

@end
