//
//  MIDClickpayTokenRequest.h
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 06/12/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIDTokenizable.h"

NS_ASSUME_NONNULL_BEGIN

@interface MIDClickpayTokenize : NSObject <MIDTokenizable>

- (instancetype)initWithCardNumber:(NSString *)cardNumber;

@end

NS_ASSUME_NONNULL_END
