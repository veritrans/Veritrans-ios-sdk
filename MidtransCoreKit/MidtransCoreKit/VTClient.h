//
//  VTClient.h
//  MidtransCoreKit
//
//  Created by Akbar Taufiq Herlangga on 3/8/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "VTCreditCard.h"
#import "VTTokenRequest.h"
#import "VTRegisteredCreditCard.h"

@interface VTClient : NSObject

+ (id)sharedClient;

- (void)generateToken:(VTTokenRequest *)tokenRequest
           completion:(void (^)(NSString *token, NSError *error))completion;

- (void)registerCreditCard:(VTCreditCard *)creditCard
                completion:(void (^)(VTRegisteredCreditCard *registeredCard, NSError *))completion;


@end
