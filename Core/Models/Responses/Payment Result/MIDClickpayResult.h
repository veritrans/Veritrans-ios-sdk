//
//  MIDClickpayResult.h
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 06/12/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import "MIDPaymentResult.h"

NS_ASSUME_NONNULL_BEGIN

@interface MIDClickpayResult : MIDPaymentResult

@property (nonatomic) NSString *approvalCode;
@property (nonatomic) NSString *maskedCard;
@property (nonatomic) NSString *settlementTime;

@end

NS_ASSUME_NONNULL_END
