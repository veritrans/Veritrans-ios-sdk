//
//  VTMerchantClient.h
//  iossdk-gojek
//
//  Created by Akbar Taufiq Herlangga on 3/10/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VTTransaction.h"
#import "VTTransactionResult.h"
#import "VTMaskedCreditCard.h"
#import "VTTransactionResult.h"

/**
 `VTMerchant` wraps operation that offered by the Merchant Server. Note that data format is tightly-coupled with the merchant server implementation. Please refer to the Merchant Server documentation for further information.
 */
@interface VTMerchantClient : NSObject

///--------------------
/// @name Instantiation
///--------------------

/**
 Get the only instance of this object.
 */
+ (id)sharedClient;


///--------------------------
/// @name Merchant Client API
///--------------------------

/**
 Perform credit card transaction.
 
 @param transaction Object that holds various information about the transaction.
 
 @param completion A callback that will be executed when the transaction finishes. If the transaction succeeded, the `result` variable will contain all the information provided from the server.
 */
- (void)performTransaction:(VTTransaction *)transaction completion:(void(^)(VTTransactionResult *result, NSError *error))completion;

/**
 Save credit card partial information to the Merchant Server. The partial credit card information is modeled using `VTMaskedCreditCard`. This `VTMaskedCreditCard` instance can be fetched using method `registerCreditCard:completion` in `VTClient`.
 */
- (void)saveRegisteredCard:(VTMaskedCreditCard *)savedCard completion:(void(^)(id result, NSError *error))completion;

/**
 Fetch saved partial information about credit cards from Merchant Server.
 */
- (void)fetchMaskedCardsWithCompletion:(void(^)(NSArray *maskedCards, NSError *error))completion;

- (void)fetchMerchantAuthDataWithCompletion:(void(^)(id response, NSError *error))completion;

- (void)deleteMaskedCard:(VTMaskedCreditCard *)maskedCard completion:(void(^)(BOOL success, NSError *error))completion;

@end
