//
//  MIDTelkomselCashPayment.h
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 20/02/19.
//  Copyright © 2019 Midtrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIDPayable.h"

NS_ASSUME_NONNULL_BEGIN

@interface MIDTelkomselCashPayment : NSObject<MIDPayable>

@property (nonatomic) NSString *customer;

/**
 Customer is Telkomsel's phone number or MSISDN 
 */
- (instancetype)initWithCustomer:(NSString *)customer;

@end

NS_ASSUME_NONNULL_END
