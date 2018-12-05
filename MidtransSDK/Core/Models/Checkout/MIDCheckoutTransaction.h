//
//  MIDTransaction.h
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 10/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

/**
 Specific information regarding the transaction
 */

#import <Foundation/Foundation.h>
#import "MIDCheckoutable.h"

NS_ASSUME_NONNULL_BEGIN

@interface MIDCheckoutTransaction : NSObject<MIDCheckoutable>

@property (nonatomic) NSString *orderID;
@property (nonatomic) NSNumber *grossAmount;

/**
 Specific information regarding the transaction
 
 @param orderID     Unique transaction ID. A single ID could be used only once by a Merchant.
 NOTE: Allowed Symbols are dash(-), underscore(_), tilde (~), and dot (.)
 @param grossAmount Amount to be charged
 substring it covered.
 */
- (instancetype)initWithOrderID:(NSString *)orderID grossAmount:(NSNumber *)grossAmount;

@end

NS_ASSUME_NONNULL_END
