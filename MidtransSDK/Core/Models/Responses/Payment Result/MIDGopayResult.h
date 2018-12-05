//
//  MIDGopayResult.h
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 04/12/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MIDPaymentResult.h"

NS_ASSUME_NONNULL_BEGIN

@interface MIDGopayResult : MIDPaymentResult

@property (nonatomic) NSString *qrCodeURL;
@property (nonatomic) NSString *expiration;
@property (nonatomic) NSString *expirationRaw;
@property (nonatomic) NSString *deepLinkURL;

@end

NS_ASSUME_NONNULL_END
