//
//  MidtransPaymentRequestV2Callbacks.m
//
//  Created by Ratna Kumalasari on 10/25/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "MidtransPaymentRequestV2Callbacks.h"


NSString *const kMidtransPaymentRequestV2CallbacksError = @"error";
NSString *const kMidtransPaymentRequestV2CallbacksFinish = @"finish";


@interface MidtransPaymentRequestV2Callbacks ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation MidtransPaymentRequestV2Callbacks

@synthesize error = _error;
@synthesize finish = _finish;


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
            self.error = [self objectOrNilForKey:kMidtransPaymentRequestV2CallbacksError fromDictionary:dict];
            self.finish = [self objectOrNilForKey:kMidtransPaymentRequestV2CallbacksFinish fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.error forKey:kMidtransPaymentRequestV2CallbacksError];
    [mutableDict setValue:self.finish forKey:kMidtransPaymentRequestV2CallbacksFinish];

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

    self.error = [aDecoder decodeObjectForKey:kMidtransPaymentRequestV2CallbacksError];
    self.finish = [aDecoder decodeObjectForKey:kMidtransPaymentRequestV2CallbacksFinish];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_error forKey:kMidtransPaymentRequestV2CallbacksError];
    [aCoder encodeObject:_finish forKey:kMidtransPaymentRequestV2CallbacksFinish];
}

- (id)copyWithZone:(NSZone *)zone
{
    MidtransPaymentRequestV2Callbacks *copy = [[MidtransPaymentRequestV2Callbacks alloc] init];
    
    if (copy) {

        copy.error = [self.error copyWithZone:zone];
        copy.finish = [self.finish copyWithZone:zone];
    }
    
    return copy;
}


@end
