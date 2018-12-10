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

NS_ASSUME_NONNULL_BEGIN

@interface MIDEWalletCharge : NSObject

+ (void)gopayWithToken:(NSString *)token
            completion:(void (^_Nullable) (MIDGopayResult *_Nullable result, NSError *_Nullable error))completion;

+ (void)tcashWithToken:(NSString *)token
           phoneNumber:(NSString *)phoneNumber
            completion:(void (^_Nullable) (MIDPaymentResult *_Nullable result, NSError *_Nullable error))completion;

+ (void)mandiriECashWithToken:(NSString *)token
                   completion:(void (^_Nullable) (MIDWebPaymentResult *_Nullable result, NSError *_Nullable error))completion;

@end

NS_ASSUME_NONNULL_END
