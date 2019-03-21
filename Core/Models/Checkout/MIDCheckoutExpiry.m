//
//  MIDCheckoutExpiry.m
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 22/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import "MIDCheckoutExpiry.h"
#import "MIDModelHelper.h"

@implementation MIDCheckoutExpiry

- (instancetype)initWithStartDate:(NSDate *)date duration:(NSInteger)duration unit:(MIDExpiryTimeUnit)unit {
    if (self = [super init]) {
        self.startDate = date;
        self.duration = duration;
        self.unit = unit;
        
    }
    return self;
}

- (NSDictionary *)dictionaryValue {
    NSString *startTime = [NSString stringFromDate:self.startDate format:@"yyyy-MM-dd HH:mm:ss Z"];
    NSDictionary *expiry =  @{@"start_time": startTime,
                              @"duration": @(self.duration),
                              @"unit": [NSString nameOfExpiryUnit: self.unit]
                              };
    return @{@"expiry": expiry};
}

@end
