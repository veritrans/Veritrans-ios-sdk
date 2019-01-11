//
//  MIDCheckoutExpiry.h
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 22/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIDCheckoutable.h"
#import "MIDModelEnums.h"

NS_ASSUME_NONNULL_BEGIN

@interface MIDCheckoutExpiry : NSObject<MIDCheckoutable>

@property (nonatomic) MIDExpiryTimeUnit unit;
@property (nonatomic) NSDate *startDate;
@property (nonatomic) NSInteger duration;

/**
 Note: If this parameter is not sent, the default expiry for snap token is 24 hours from the time the token was created. Furthermore, if only unit and duration is given, start_time will equal the timestamp of the token creation.
 
 @param date If not specified, transaction time will be used as start time (when customer charge)
 @param duration Expiry duration
 @param unit Expiry unit. Options: day, hour, minute (plural term also accepted)
 */
- (instancetype)initWithStartDate:(NSDate *)date duration:(NSInteger)duration unit:(MIDExpiryTimeUnit)unit;

@end

NS_ASSUME_NONNULL_END
