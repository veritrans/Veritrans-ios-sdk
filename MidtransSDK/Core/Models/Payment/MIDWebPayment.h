//
//  MIDAkulakuPayment.h
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 21/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIDPayable.h"
#import "MIDModelEnums.h"

NS_ASSUME_NONNULL_BEGIN

@interface MIDWebPayment : NSObject<MIDPayable>

@property (nonatomic) MIDWebPaymentType type;

- (instancetype)initWithType:(MIDWebPaymentType)type;

@end

NS_ASSUME_NONNULL_END
