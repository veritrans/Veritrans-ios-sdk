//
//  MIDExbinResponse.m
//  MidtransCoreKit
//
//  Created by Muhammad Fauzi Masykur on 04/04/22.
//  Copyright © 2022 Midtrans. All rights reserved.
//

#import "MIDExbinResponse.h"

NSString *const KMidtransExbinData = @"data";

@implementation MIDExbinResponse

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
        self.data = [MIDExbinData modelObjectWithDictionary:[dict objectForKey:KMidtransExbinData]];
    }
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[self.data dictionaryRepresentation] forKey:KMidtransExbinData];
    
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

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    self.data = [aDecoder decodeObjectForKey:KMidtransExbinData];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.data forKey:KMidtransExbinData];
}

- (id)copyWithZone:(NSZone *)zone
{
    MIDExbinResponse *copy = [[MIDExbinResponse alloc] init];
    
    if (copy) {
        copy.data = [self.data copyWithZone:zone];
    }
    
    return copy;
}

@end
