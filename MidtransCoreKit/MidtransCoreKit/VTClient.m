//
//  VTClient.m
//  MidtransCoreKit
//
//  Created by Akbar Taufiq Herlangga on 3/8/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTClient.h"

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

- (void)generateTokenForCreditCard:(VTCreditCard *)creditCard completion:(void (^)(NSString *, NSError *))callback {
    
}

- (void)registerCreditCard:(VTCreditCard *)creditCard completion:(void (^)(NSString *, NSError *))callback {
    
}

@end
