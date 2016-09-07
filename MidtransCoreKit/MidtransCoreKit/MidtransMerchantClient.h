//
//  VTMerchantClient.h
//  iossdk-gojek
//
//  Created by Akbar Taufiq Herlangga on 3/10/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MidtransTransaction.h"
#import "MidtransTransactionDetails.h"
#import "MidtransTransactionResult.h"
#import "MidtransMaskedCreditCard.h"
#import "MidtransTransactionResult.h"
@class MidtransTransactionTokenResponse,MidtransPaymentRequestResponse;
/**
 `VTMerchant` wraps operation that offered by the Merchant Server. Note that data format is tightly-coupled with the merchant server implementation. Please refer to the Merchant Server documentation for further information.
 */
@interface MidtransMerchantClient : NSObject

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
- (void)performTransaction:(MidtransTransaction *_Nonnull)transaction completion:(void(^_Nullable)(MidtransTransactionDetails *_Nullable result, NSError *_Nullable error))completion;

/**
 Save credit card partial information to the Merchant Server. The partial
 credit card information is modeled using `MTMaskedCreditCard`. This `MTMaskedCreditCard` instance can be fetched using method `registerCreditCard:completion` in `VTClient`.
 */
- (void)saveMaskedCards:(NSArray <MidtransMaskedCreditCard*>*_Nonnull)maskedCards customer:(MidtransCustomerDetails *_Nonnull)customer completion:(void(^_Nullable)(id _Nullable result, NSError *_Nullable error))completion;

/**
 Fetch saved partial information about credit cards from Merchant Server.
 */

- (void)fetchMaskedCardsCustomer:(MidtransCustomerDetails *_Nonnull)customer completion:(void(^_Nullable)(NSArray *_Nullable maskedCards, NSError *_Nullable error))completion;

/*
 * updated method, snapping
 */
- (void)requestTransactionTokenWithTransactionDetails:(nonnull MidtransTransactionDetails *)transactionDetails
                                          itemDetails:(nullable NSArray<MidtransItemDetail*> *)itemDetails
                                      customerDetails:(nullable MidtransCustomerDetails *)customerDetails
                                           completion:(void (^_Nullable)(MidtransTransactionTokenResponse *_Nullable token, NSError *_Nullable error))completion;

- (void)requestPaymentlistWithToken:(NSString * _Nonnull )token completion:(void (^_Nullable)(MidtransPaymentRequestResponse *_Nullable response, NSError *_Nullable error))completion;
@end
