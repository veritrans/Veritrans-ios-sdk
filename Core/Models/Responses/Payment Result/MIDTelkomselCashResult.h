//
//  MIDTelkomselCashResult.h
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 20/02/19.
//  Copyright © 2019 Midtrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIDPaymentResult.h"

NS_ASSUME_NONNULL_BEGIN

@interface MIDTelkomselCashResult : MIDPaymentResult

@property (nonatomic) NSString *settlementTime;

@end

NS_ASSUME_NONNULL_END
