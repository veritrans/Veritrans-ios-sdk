//
//  MIDTransaction.h
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 10/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIDMappable.h"

NS_ASSUME_NONNULL_BEGIN

@interface MIDTransaction : NSObject<MIDMappable>

@property (nonatomic) NSString *orderID;
@property (nonatomic) NSNumber *grossAmount;

+ (instancetype)modelWithOrderID:(NSString *)orderID grossAmount:(NSNumber *)grossAmount;

@end

NS_ASSUME_NONNULL_END
