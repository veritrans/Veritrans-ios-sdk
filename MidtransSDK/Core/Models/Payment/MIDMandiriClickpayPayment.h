//
//  MIDMandiriClickpayPayment.h
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 21/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIDPayment.h"

NS_ASSUME_NONNULL_BEGIN

@interface MIDMandiriClickpayPayment : NSObject<MIDPayment>

@property (nonatomic) NSString *cardToken;
@property (nonatomic) NSString *clickpayToken;

- (instancetype)initWithCardToken:(NSString *)cardToken clickpayToken:(NSString *)clickpayToken;

@end

NS_ASSUME_NONNULL_END
