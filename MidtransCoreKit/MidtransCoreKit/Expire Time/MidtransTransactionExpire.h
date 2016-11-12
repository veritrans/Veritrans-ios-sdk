//
//  TransactionExpire.h
//
//  Created by Ratna Kumalasari on 11/4/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, MindtransTimeUnitType) {
    MindtransTimeUnitTypeMinute,
    MindtransTimeUnitTypeMinutes,
    MindtransTimeUnitTypeHour,
    MindtransTimeUnitTypeHours,
    MindtransTimeUnitTypeDay,
    MindtransTimeUnitTypeDays
};

@interface MidtransTransactionExpire : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, assign) double duration;
@property (nonatomic, strong) NSString *unit;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;
- (instancetype)initWithExpireTime:(NSDate *)startTime expireDuration:(NSInteger)expireDuration withUnitTime:(MindtransTimeUnitType)unitTime;

@end
