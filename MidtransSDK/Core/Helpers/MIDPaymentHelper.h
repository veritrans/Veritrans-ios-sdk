//
//  MIDPaymentHelper.h
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 03/12/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIDPayable.h"

NS_ASSUME_NONNULL_BEGIN

@interface MIDPaymentHelper : NSObject

+ (void)performPayment:(NSObject<MIDPayable> *)payment
                 token:(NSString *)token
            completion:(void (^)(id _Nullable response, NSError * _Nullable))completion;

@end

NS_ASSUME_NONNULL_END
