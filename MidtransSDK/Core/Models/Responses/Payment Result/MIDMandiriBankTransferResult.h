//
//  MIDMandiriBankTransferResult.h
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 03/12/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIDPaymentResult.h"

NS_ASSUME_NONNULL_BEGIN

@interface MIDMandiriBankTransferResult : MIDPaymentResult

@property (nonatomic) NSString *expiration;
@property (nonatomic) NSString *key;
@property (nonatomic) NSString *code;

@end

NS_ASSUME_NONNULL_END
