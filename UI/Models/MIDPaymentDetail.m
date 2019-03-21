//
//  MIDPaymentDetail.m
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 14/02/19.
//  Copyright © 2019 Midtrans. All rights reserved.
//

#import "MIDPaymentDetail.h"

NSString *const kMIDPaymentDetailId = @"id";
NSString *const kMIDPaymentDetailLocalIdentifier = @"identifier";
NSString *const kMIDPaymentDetailTitle = @"title";
NSString *const kMIDPaymentDetailShortName = @"shortName";
NSString *const kMIDPaymentDetailDescription = @"description";

@interface MIDPaymentDetail ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation MIDPaymentDetail

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
        self.paymentID = [self objectOrNilForKey:kMIDPaymentDetailId fromDictionary:dict];
        self.paymentDescription = [self objectOrNilForKey:kMIDPaymentDetailDescription fromDictionary:dict];
        self.paymentIdentifier = [self objectOrNilForKey:kMIDPaymentDetailLocalIdentifier fromDictionary:dict];
        self.title = [self objectOrNilForKey:kMIDPaymentDetailTitle fromDictionary:dict];
        self.shortName = [self objectOrNilForKey:kMIDPaymentDetailShortName fromDictionary:dict];
        
        self.method = [[self objectOrNilForKey:kMIDPaymentDetailId fromDictionary:dict] paymentMethod];
    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.paymentID forKey:kMIDPaymentDetailId];
    [mutableDict setValue:self.paymentIdentifier forKey:kMIDPaymentDetailLocalIdentifier];
    [mutableDict setValue:self.paymentDescription forKey:kMIDPaymentDetailDescription];
    [mutableDict setValue:self.title forKey:kMIDPaymentDetailTitle];
    [mutableDict setValue:self.shortName forKey:kMIDPaymentDetailShortName];
    
    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description  {
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict {
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    
    self.paymentID = [aDecoder decodeObjectForKey:kMIDPaymentDetailId];
    self.title = [aDecoder decodeObjectForKey:kMIDPaymentDetailTitle];
    self.shortName = [aDecoder decodeObjectForKey:kMIDPaymentDetailShortName];
    self.paymentIdentifier = [aDecoder decodeObjectForKey:kMIDPaymentDetailLocalIdentifier];
    self.paymentDescription = [aDecoder decodeObjectForKey:kMIDPaymentDetailDescription];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:_paymentID forKey:kMIDPaymentDetailId];
    [aCoder encodeObject:_title forKey:kMIDPaymentDetailTitle];
    [aCoder encodeObject:_paymentDescription forKey:kMIDPaymentDetailDescription];
}

- (id)copyWithZone:(NSZone *)zone {
    MIDPaymentDetail *copy = [[MIDPaymentDetail alloc] init];
    
    if (copy) {
        copy.paymentID = [self.paymentID copyWithZone:zone];
        copy.paymentIdentifier = [self.paymentIdentifier copyWithZone:zone];
        copy.title = [self.title copyWithZone:zone];
        copy.paymentDescription = [self.paymentDescription copyWithZone:zone];
    }
    
    return copy;
}


@end
