//
//  MIDCheckoutGoPay.h
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 22/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIDCheckoutOption.h"

NS_ASSUME_NONNULL_BEGIN

@interface MIDCheckoutGoPay : NSObject<MIDCheckoutOption>

- (instancetype)initWithCallbackSchemeURL:(NSString *)callbackURL;

@end

NS_ASSUME_NONNULL_END
