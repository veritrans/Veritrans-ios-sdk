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
#import "VTMaskedCreditCard.h"

/**
 `VTClient` wraps various services offered by Veritrans server. Note that Veritrans offers many payment services, but not all of wrapped by this object because most the of service are supposed to be executed server-side.
 */
@interface VTClient : NSObject

///--------------------
/// @name Instantiation
///--------------------

/**
 Return a shared instance of `VTClient`.
 */
+ (id)sharedClient;


///--------------------
/// @name Veritrans API
///--------------------

/**
 Generate a token from Veritrans server. This token will be used as a representation of a unique credit card for later transaction.
 
 @param tokenRequest Object that contains various information to be "transformed" into a token. Supplying the credit card information is mandatory.
 
 @param completion A callback that will be called when the operation finished. When the operation succeeded, the generated token will be in be in `token` variable.
 */
- (void)generateToken:(VTTokenRequest *)tokenRequest
           completion:(void (^)(NSString *token, NSError *error))completion;

/**
 Register a credit card to be stored in Veritrans server.
 
 @param creditCard `VTCreditCard` object that contains information of the credit card.
 
 @param completion A callback that will be called when the operation finished. When the operation succeeded, the completion will contain `VTMaskedCreditCard` object.
 */
- (void)registerCreditCard:(VTCreditCard *)creditCard
                completion:(void (^)(VTMaskedCreditCard *maskedCard, NSError *error))completion;


@end
