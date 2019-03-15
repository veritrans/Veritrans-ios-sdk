//
//  MIDDirectDebitCharge.h
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 04/12/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIDWebPaymentResult.h"
#import "MIDClickpayResult.h"
#import "MIDKlikbcaResult.h"

NS_ASSUME_NONNULL_BEGIN

@interface MIDDirectDebitCharge : NSObject

+ (void)bcaKlikPayWithToken:(NSString *)token
                 completion:(void (^_Nullable) (MIDWebPaymentResult *_Nullable result, NSError *_Nullable error))completion;

+ (void)cimbClicksWithToken:(NSString *)token
                 completion:(void (^_Nullable) (MIDWebPaymentResult *_Nullable result, NSError *_Nullable error))completion;

+ (void)briEpayWithToken:(NSString *)token
              completion:(void (^_Nullable) (MIDWebPaymentResult *_Nullable result, NSError *_Nullable error))completion;

+ (void)danamonOnlineWithToken:(NSString *)token
                    completion:(void (^_Nullable) (MIDWebPaymentResult *_Nullable result, NSError *_Nullable error))completion;

/**
 Input3 is random number with 5 maximum length
 */
+ (void)mandiriClickpayWithToken:(NSString *)snapToken
                      cardNumber:(NSString *)cardNumber
                   clickpayToken:(NSString *)clickpayToken
                          input3:(NSString *)input3
                      completion:(void (^)(MIDClickpayResult *_Nullable result, NSError *_Nullable error))completion;

+ (void)klikbcaWithToken:(NSString *)token
                  userID:(NSString *)userID
              completion:(void (^)(MIDKlikbcaResult *_Nullable result, NSError *_Nullable error))completion;

@end

NS_ASSUME_NONNULL_END
