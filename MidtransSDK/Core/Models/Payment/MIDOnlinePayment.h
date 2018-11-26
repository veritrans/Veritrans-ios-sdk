//
//  MIDAkulakuPayment.h
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 21/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIDPayment.h"
#import "MIDModelEnums.h"

NS_ASSUME_NONNULL_BEGIN

@interface MIDOnlinePayment : NSObject<MIDPayment>

@property (nonatomic) MIDOnlinePaymentType type;

- (instancetype)initWithType:(MIDOnlinePaymentType)type;

@end

NS_ASSUME_NONNULL_END
