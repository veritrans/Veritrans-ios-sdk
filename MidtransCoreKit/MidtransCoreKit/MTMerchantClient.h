//
//  VTMerchantClient.h
//  iossdk-gojek
//
//  Created by Akbar Taufiq Herlangga on 3/10/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VTTransaction.h"
#import "VTTransactionDetails.h"
#import "MTTransactionResult.h"
#import "MTMaskedCreditCard.h"
#import "MTTransactionResult.h"
@class MTTransactionTokenResponse,MTPaymentRequestResponse;
/**
 `VTMerchant` wraps operation that offered by the Merchant Server. Note that data format is tightly-coupled with the merchant server implementation. Please refer to the Merchant Server documentation for further information.
 */
@interface MTMerchantClient : NSObject

///--------------------
/// @name Instantiation
///--------------------

/**
 Get the only instance of this object.
 */
+ (id _Nonnull)sharedClient;


///--------------------------
/// @name Merchant Client API
///--------------------------

/**
 Perform credit card transaction.
 
 @param transaction Object that holds various information about the transaction.
 
 @param completion A callback that will be executed when the transaction finishes. If the transaction succeeded, the `result` variable will contain all the information provided from the server.
 */
- (void)performTransaction:(VTTransaction *_Nonnull)transaction completion:(void(^_Nullable)(MTTransactionResult *_Nullable result, NSError *_Nullable error))completion;

/**
 Save credit card partial information to the Merchant Server. The partial
 credit card information is modeled using `MTMaskedCreditCard`. This `MTMaskedCreditCard` instance can be fetched using method `registerCreditCard:completion` in `VTClient`.
 */
- (void)saveMaskedCards:(NSArray <MTMaskedCreditCard*>*_Nonnull)maskedCards customer:(MTCustomerDetails *_Nonnull)customer completion:(void(^_Nullable)(id _Nullable result, NSError *_Nullable error))completion;

/**
 Fetch saved partial information about credit cards from Merchant Server.
 */

- (void)fetchMaskedCardsCustomer:(MTCustomerDetails *_Nonnull)customer completion:(void(^_Nullable)(NSArray *_Nullable maskedCards, NSError *_Nullable error))completion;

/*
 * updated method, snapping
 */
- (void)requestTransactionTokenWithTransactionDetails:(nonnull VTTransactionDetails *)transactionDetails
                                          itemDetails:(nullable NSArray<MTItemDetail*> *)itemDetails
                                      customerDetails:(nullable MTCustomerDetails *)customerDetails
                                           completion:(void (^_Nullable)(MTTransactionTokenResponse *_Nullable token, NSError *_Nullable error))completion;

- (void)requestPaymentlistWithToken:(NSString * _Nonnull )token completion:(void (^_Nullable)(MTPaymentRequestResponse *_Nullable response, NSError *_Nullable error))completion;
@end
