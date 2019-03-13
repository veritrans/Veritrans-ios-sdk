//
//  MIDIndomaretResult.h
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 04/12/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "MIDPaymentResult.h"

NS_ASSUME_NONNULL_BEGIN

@interface MIDCStoreResult : MIDPaymentResult

@property (nonatomic) NSString *paymentCode;
@property (nonatomic) NSString *store;

@end

NS_ASSUME_NONNULL_END
