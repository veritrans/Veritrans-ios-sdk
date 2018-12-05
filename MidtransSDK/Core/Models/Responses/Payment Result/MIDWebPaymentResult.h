//
//  MIDWebPaymentResult.h
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 05/12/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import "MIDPaymentResult.h"

NS_ASSUME_NONNULL_BEGIN

@interface MIDWebPaymentResult : MIDPaymentResult

/**
 Online payment web URL
 */
@property (nonatomic) NSString *redirectURL;


@end

NS_ASSUME_NONNULL_END
