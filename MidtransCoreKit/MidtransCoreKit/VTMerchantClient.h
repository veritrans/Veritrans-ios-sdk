//
//  VTMerchantClient.h
//  MidtransCoreKit
//
//  Created by Akbar Taufiq Herlangga on 3/10/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VTCTransactionData.h"
#import "VTMaskedCreditCard.h"
#import "VTPaymentResult.h"

@interface VTMerchantClient : NSObject

+ (id)sharedClient;

- (void)performCreditCardTransaction:(VTCTransactionData *)transaction completion:(void(^)(VTPaymentResult *result, NSError *error))completion;

- (void)saveRegisteredCard:(id)savedCard completion:(void(^)(id response, NSError *error))completion;

- (void)fetchMaskedCardsWithCompletion:(void(^)(NSArray *maskedCards, NSError *error))completion;

- (void)fetchMerchantAuthDataWithCompletion:(void(^)(id response, NSError *error))completion;

- (void)deleteMaskedCard:(VTMaskedCreditCard *)maskedCard completion:(void(^)(BOOL success, NSError *error))completion;

@end
