//
//  VTClient.h
//  MidtransCoreKit
//
//  Created by Akbar Taufiq Herlangga on 3/8/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VTCreditCard.h"

@interface VTClient : NSObject

+ (id)sharedClient;

- (void)generateTokenForCreditCard:(VTCreditCard *)creditCard
                        completion:(void (^)(NSString *, NSError *))callback;

- (void)registerCreditCard:(VTCreditCard *)creditCard
                completion:(void (^)(NSString *, NSError *))callback;


@end
