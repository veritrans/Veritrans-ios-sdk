//
//  MIDPromoOption.h
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 04/03/19.
//  Copyright © 2019 Midtrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIDCheckoutable.h"

NS_ASSUME_NONNULL_BEGIN

@interface MIDPromoOption : NSObject<MIDCheckoutable>

- (instancetype)initWithPromoID:(NSNumber *)promoID discountedGrossAmount:(NSNumber *)discountedGrossAmount;

@property (nonatomic) NSNumber *promoID;
@property (nonatomic) NSNumber *discountedGrossAmount;

@end

NS_ASSUME_NONNULL_END
