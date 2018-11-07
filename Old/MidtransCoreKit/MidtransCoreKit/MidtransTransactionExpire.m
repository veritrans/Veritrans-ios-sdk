//
//  TransactionExpire.m
//
//  Created by Ratna Kumalasari on 11/4/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "MidtransTransactionExpire.h"


NSString *const kTransactionExpireStartTime = @"start_time";
NSString *const kTransactionExpireDuration = @"duration";
NSString *const kTransactionExpireUnit = @"unit";

@interface MidtransTransactionExpire ()
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;
@property (nonatomic,strong)NSDate *startTimeFromNSDate;
@end

@implementation MidtransTransactionExpire

@synthesize startTime = _startTime;
@synthesize duration = _duration;
@synthesize unit = _unit;


- (instancetype)initWithExpireTime:(NSDate *)startTime expireDuration:(NSInteger)expireDuration withUnitTime:(MindtransTimeUnitType)unitTime {
    if (self = [super init]) {
        self.duration = expireDuration;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
        self.startTime = [dateFormatter stringFromDate:startTime];
        switch (unitTime) {
            case MindtransTimeUnitTypeDay:
                self.unit = @"DAY";
                break;
            case MindtransTimeUnitTypeDays:
                self.unit = @"DAYS";
                break;
            case MindtransTimeUnitTypeMinute:
                self.unit = @"MINUTE";
                break;
            case MindtransTimeUnitTypeMinutes:
                self.unit = @"MINUTES";
                break;
            case MindtransTimeUnitTypeHour:
                self.unit = @"HOUR";
                break;
            case MindtransTimeUnitTypeHours:
                self.unit = @"HOURS";
                break;
            default:
                self.unit = @"HOUR";
                break;
        }
    }
    return self;
}
+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.startTime = [self objectOrNilForKey:kTransactionExpireStartTime fromDictionary:dict];
            self.duration = [[self objectOrNilForKey:kTransactionExpireDuration fromDictionary:dict] doubleValue];
            self.unit = [self objectOrNilForKey:kTransactionExpireUnit fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.startTime forKey:kTransactionExpireStartTime];
    [mutableDict setValue:[NSNumber numberWithDouble:self.duration] forKey:kTransactionExpireDuration];
    [mutableDict setValue:self.unit forKey:kTransactionExpireUnit];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description 
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    self.startTime = [aDecoder decodeObjectForKey:kTransactionExpireStartTime];
    self.duration = [aDecoder decodeDoubleForKey:kTransactionExpireDuration];
    self.unit = [aDecoder decodeObjectForKey:kTransactionExpireUnit];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_startTime forKey:kTransactionExpireStartTime];
    [aCoder encodeDouble:_duration forKey:kTransactionExpireDuration];
    [aCoder encodeObject:_unit forKey:kTransactionExpireUnit];
}

- (id)copyWithZone:(NSZone *)zone
{
    MidtransTransactionExpire *copy = [[MidtransTransactionExpire alloc] init];
    
    if (copy) {

        copy.startTime = [self.startTime copyWithZone:zone];
        copy.duration = self.duration;
        copy.unit = [self.unit copyWithZone:zone];
    }
    
    return copy;
}


@end
