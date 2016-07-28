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
#import "VTTransactionResult.h"
#import "VTMaskedCreditCard.h"
#import "VTTransactionResult.h"
@class SnapTokenResponse,PaymentRequestResponse;
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
+ (id _Nonnull)sharedClient;


///--------------------------
/// @name Merchant Client API
///--------------------------

/**
 Perform credit card transaction.
 
 @param transaction Object that holds various information about the transaction.
 
 @param completion A callback that will be executed when the transaction finishes. If the transaction succeeded, the `result` variable will contain all the information provided from the server.
 */
- (void)performTransaction:(VTTransaction *_Nonnull)transaction completion:(void(^_Nullable)(VTTransactionResult *_Nullable result, NSError *_Nullable error))completion;

/**
 Save credit card partial information to the Merchant Server. The partial credit card information is modeled using `VTMaskedCreditCard`. This `VTMaskedCreditCard` instance can be fetched using method `registerCreditCard:completion` in `VTClient`.
 */
- (void)saveRegisteredCard:(VTMaskedCreditCard *_Nonnull)savedCard completion:(void(^_Nullable)(id _Nullable result, NSError *_Nullable error))completion;

/**
 Fetch saved partial information about credit cards from Merchant Server.
 */
- (void)fetchMaskedCardsWithCompletion:(void(^_Nullable)(NSArray *_Nullable maskedCards, NSError *_Nullable error))completion;
- (void)fetchMerchantAuthDataWithCompletion:(void(^_Nullable)(id _Nullable response, NSError *_Nullable error))completion;
- (void)deleteMaskedCard:(VTMaskedCreditCard *_Nonnull)maskedCard completion:(void(^_Nullable)(BOOL success, NSError *_Nullable error))completion;

/*
 * updated method, snapping
 */
- (void)fetchPaymentListWithTransactionDetails:(nonnull VTTransactionDetails *)transactionDetails
                                   itemDetails:(nullable NSArray<VTItemDetail*> *)itemDetails
                               customerDetails:(nullable VTCustomerDetails *)customerDetails
                                    completion:(void (^_Nullable)(PaymentRequestResponse *_Nullable response, NSError *_Nullable error))completion;

@end
