//
//  MIDDirectDebitCharge.h
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 04/12/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIDWebPaymentResult.h"

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

+ (void)mandiriClickpayWithToken:(NSString *)token
                       cardToken:(NSString *)cardToken
                   clickpayToken:(NSString *)clickpayToken
                      completion:(void (^_Nullable) (id *_Nullable result, NSError *_Nullable error))completion;

@end

NS_ASSUME_NONNULL_END
