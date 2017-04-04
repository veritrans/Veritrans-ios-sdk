//
//  VTClient.h
//  iossdk-gojek
//
//  Created by Akbar Taufiq Herlangga on 3/8/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "MidtransCreditCard.h"
#import "MidtransTokenizeRequest.h"
#import "MidtransMaskedCreditCard.h"
#import "MidtransTransactionResult.h"

/**
 `VTClient` wraps various services offered by Veritrans server. Note that Veritrans offers many payment services, but not all of wrapped by this object because most the of service are supposed to be executed server-side.
 */
@interface MidtransClient : NSObject

///--------------------
/// @name Instantiation
///--------------------

/**
 Return a shared instance of `VTClient`.
 */
+ (MidtransClient *_Nonnull)shared;


///---------------------------
/// @name Veritrans Client API
///---------------------------

/**
 Generate a token from Veritrans server. This token will be used as a representation of a unique credit card for later transaction.
 
 @param tokenizeRequest Object that contains various information to be "transformed" into a token. Supplying the credit card information is mandatory.
 
 @param completion A callback that will be called when the operation finished. When the operation succeeded, the generated token will be passed as `token` variable.
 */
- (void)generateToken:(MidtransTokenizeRequest *_Nonnull)tokenizeRequest
           completion:(void (^_Nullable)(NSString *_Nullable token, NSError *_Nullable error))completion;

/**
 Register a credit card to be stored in Veritrans server.
 
 @param response `NSDictionary` object that contains information of the credit card.
 
 @param completion A callback that will be called when the operation finished. When the operation succeeded, the completion will contain registered credit card object.
 */
- (void)requestCardBINForInstallmentWithCompletion:(void (^_Nullable)(NSArray *_Nullable binResponse, NSError *_Nullable error))completion;

- (void)registerCreditCard:(MidtransCreditCard *_Nonnull)creditCard
                completion:(void (^_Nullable)(MidtransMaskedCreditCard *_Nullable maskedCreditCard, NSError *_Nullable error))completion;

+ (BOOL)isCreditCardNumber:(NSString *_Nonnull)ccNumber eligibleForBins:(NSArray *_Nonnull)bins error:(NSError *_Nullable*_Nullable)error;
@end
