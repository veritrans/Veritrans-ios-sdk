//
//  MIDKlikbcaResult.h
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 07/12/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import "MIDPaymentResult.h"

NS_ASSUME_NONNULL_BEGIN

@interface MIDKlikbcaResult : MIDPaymentResult

@property (nonatomic) NSString *approvalCode;
@property (nonatomic) NSString *redirectURL;

@end

NS_ASSUME_NONNULL_END
