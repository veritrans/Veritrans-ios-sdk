//
//  MIDMandiriClickpayPayment.h
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 21/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIDPayable.h"

NS_ASSUME_NONNULL_BEGIN

@interface MIDMandiriClickpayPayment : NSObject<MIDPayable>

@property (nonatomic) NSString *cardToken;
@property (nonatomic) NSString *clickpayToken;

/**
 Input3 is random number with 5 maximum length
 */
@property (nonatomic) NSString *input3;

- (instancetype)initWithCardToken:(NSString *)cardToken clickpayToken:(NSString *)clickpayToken input3:(NSString *)input3;

@end

NS_ASSUME_NONNULL_END
