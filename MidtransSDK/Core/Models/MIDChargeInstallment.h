//
//  MIDCreditCardInstallment.h
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 27/12/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIDModelEnums.h"

NS_ASSUME_NONNULL_BEGIN

@interface MIDChargeInstallment : NSObject

- (instancetype)initWithBank:(MIDAcquiringBank)bank term:(NSInteger)term;

- (NSString *)value;

@end

NS_ASSUME_NONNULL_END
