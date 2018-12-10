//
//  MIDStoreCharge.h
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 04/12/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIDIndomaretResult.h"

NS_ASSUME_NONNULL_BEGIN

@interface MIDStoreCharge : NSObject

+ (void)indomaretWithToken:(NSString *)token
                completion:(void (^_Nullable) (MIDIndomaretResult *_Nullable result, NSError *_Nullable error))completion;

@end

NS_ASSUME_NONNULL_END
