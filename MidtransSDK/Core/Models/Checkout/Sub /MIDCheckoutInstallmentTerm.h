//
//  MIDCheckoutInstallmentTerm.h
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 03/01/19.
//  Copyright © 2019 Midtrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIDCheckoutable.h"
#import "MIDModelEnums.h"

NS_ASSUME_NONNULL_BEGIN

@interface MIDCheckoutInstallmentTerm : NSObject <MIDCheckoutable>

@property (nonatomic) MIDAcquiringBank bank;
@property (nonatomic) NSArray <NSNumber *> *terms;

+ (instancetype)modelWithBank:(MIDAcquiringBank)bank terms:(NSArray <NSNumber *> *)terms;

@end

NS_ASSUME_NONNULL_END
