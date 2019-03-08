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

- (instancetype)initWithID:(NSString *)promoID discountedGrossAmount:(NSNumber *)grossAmount;

@property (nonatomic) NSString *promoID;
@property (nonatomic) NSNumber *discountedGrossAmount;

@end

NS_ASSUME_NONNULL_END
