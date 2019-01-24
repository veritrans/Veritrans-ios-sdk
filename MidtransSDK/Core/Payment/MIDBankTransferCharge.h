//
//  MIDPayment.h
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 03/12/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIDPayable.h"
#import "MIDBCABankTransferResult.h"
#import "MIDBNIBankTransferResult.h"
#import "MIDPermataBankTransferResult.h"
#import "MIDMandiriBankTransferResult.h"

NS_ASSUME_NONNULL_BEGIN

@interface MIDBankTransferCharge : NSObject

+ (void)bcaWithToken:(NSString *)token
               email:(NSString *)email
          completion:(void (^_Nullable) (MIDBCABankTransferResult *_Nullable result, NSError *_Nullable error))completion;

+ (void)permataWithToken:(NSString *)token
                   email:(NSString *)email
              completion:(void (^_Nullable) (MIDPermataBankTransferResult *_Nullable result, NSError *_Nullable error))completion;

+ (void)mandiriWithToken:(NSString *)token
                   email:(NSString *)email
              completion:(void (^_Nullable) (MIDMandiriBankTransferResult *_Nullable result, NSError *_Nullable error))completion;

+ (void)bniWithToken:(NSString *)token
               email:(NSString *)email
          completion:(void (^_Nullable) (MIDBNIBankTransferResult *_Nullable result, NSError *_Nullable error))completion;

+ (void)otherBankWithToken:(NSString *)token
                     email:(NSString *)email
                completion:(void (^_Nullable) (id _Nullable result, NSError *_Nullable error))completion;
@end

NS_ASSUME_NONNULL_END
