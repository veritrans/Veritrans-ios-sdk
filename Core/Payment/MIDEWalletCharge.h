//
//  MIDEWalletCharge.h
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 04/12/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIDGopayResult.h"
#import "MIDWebPaymentResult.h"
#import "MIDTelkomselCashResult.h"

NS_ASSUME_NONNULL_BEGIN

@interface MIDEWalletCharge : NSObject

+ (void)gopayWithToken:(NSString *)token
            completion:(void (^_Nullable) (MIDGopayResult *_Nullable result, NSError *_Nullable error))completion;

+ (void)mandiriECashWithToken:(NSString *)token
                   completion:(void (^_Nullable) (MIDWebPaymentResult *_Nullable result, NSError *_Nullable error))completion;

+ (void)telkomselCashWithToken:(NSString *)snapToken
                      customer:(NSString *)customer
                    completion:(void (^_Nullable) (MIDTelkomselCashResult *_Nullable result, NSError *_Nullable error))completion;
@end

NS_ASSUME_NONNULL_END
