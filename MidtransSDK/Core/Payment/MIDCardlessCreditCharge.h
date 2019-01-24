//
//  MIDCardlessCreditCharge.h
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 24/01/19.
//  Copyright © 2019 Midtrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIDWebPaymentResult.h"

NS_ASSUME_NONNULL_BEGIN

@interface MIDCardlessCreditCharge : NSObject

+ (void)akulakuWithToken:(NSString *)token completion:(void (^)(MIDWebPaymentResult *_Nullable result, NSError *_Nullable error))completion;

@end

NS_ASSUME_NONNULL_END
