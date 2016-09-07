//
//  VTClient.h
//  iossdk-gojek
//
//  Created by Akbar Taufiq Herlangga on 3/8/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "MTCreditCard.h"
#import "VTTokenizeRequest.h"
#import "MTMaskedCreditCard.h"
#import "MTTransactionResult.h"

/**
 `VTClient` wraps various services offered by Veritrans server. Note that Veritrans offers many payment services, but not all of wrapped by this object because most the of service are supposed to be executed server-side.
 */
@interface MTClient : NSObject

///--------------------
/// @name Instantiation
///--------------------

/**
 Return a shared instance of `VTClient`.
 */
+ (id _Nonnull)sharedClient;


///---------------------------
/// @name Veritrans Client API
///---------------------------

/**
 Generate a token from Veritrans server. This token will be used as a representation of a unique credit card for later transaction.
 
 @param tokenizeRequest Object that contains various information to be "transformed" into a token. Supplying the credit card information is mandatory.
 
 @param completion A callback that will be called when the operation finished. When the operation succeeded, the generated token will be passed as `token` variable.
 */
- (void)generateToken:(VTTokenizeRequest *_Nonnull)tokenizeRequest
           completion:(void (^_Nullable)(NSString *_Nullable token, NSError *_Nullable error))completion;

/**
 Register a credit card to be stored in Veritrans server.
 
 @param response `NSDictionary` object that contains information of the credit card.
 
 @param completion A callback that will be called when the operation finished. When the operation succeeded, the completion will contain registered credit card object.
 */
- (void)registerCreditCard:(MTCreditCard *_Nonnull)creditCard
                completion:(void (^_Nullable)(MTMaskedCreditCard *_Nullable maskedCreditCard, NSError *_Nullable error))completion;

@end
