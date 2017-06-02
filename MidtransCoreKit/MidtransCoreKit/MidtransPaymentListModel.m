//
//  VTPaymentListModel.m
//
//  Created by Arie  on 6/17/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "MidtransPaymentListModel.h"


NSString *const kVTPaymentListModelId = @"id";
NSString *const kVTPaymentListModelLocalIdentifier = @"identifier";
NSString *const kVTPaymentListModelTitle = @"title";
NSString *const kVTPaymentListModelShortName = @"shortName";
NSString *const kVTPaymentListModelDescription = @"description";


@interface MidtransPaymentListModel ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation MidtransPaymentListModel

@synthesize internalBaseClassIdentifier = _internalBaseClassIdentifier;
@synthesize title = _title;
@synthesize shortName = _shortName;
@synthesize localPaymentIdentifier = _localPaymentIdentifier;
@synthesize internalBaseClassDescription = _internalBaseClassDescription;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
        self.internalBaseClassIdentifier = [self objectOrNilForKey:kVTPaymentListModelId fromDictionary:dict];
        self.title = [self objectOrNilForKey:kVTPaymentListModelTitle fromDictionary:dict];
        self.shortName = [self objectOrNilForKey:kVTPaymentListModelShortName fromDictionary:dict];
        self.localPaymentIdentifier = [self objectOrNilForKey:kVTPaymentListModelLocalIdentifier fromDictionary:dict];
        self.internalBaseClassDescription = [self objectOrNilForKey:kVTPaymentListModelDescription fromDictionary:dict];
        
    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.internalBaseClassIdentifier forKey:kVTPaymentListModelId];
    [mutableDict setValue:self.title forKey:kVTPaymentListModelTitle];
    [mutableDict setValue:self.shortName forKey:kVTPaymentListModelShortName];
    [mutableDict setValue:self.internalBaseClassDescription forKey:kVTPaymentListModelDescription];
    
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
    
    self.internalBaseClassIdentifier = [aDecoder decodeObjectForKey:kVTPaymentListModelId];
    self.title = [aDecoder decodeObjectForKey:kVTPaymentListModelTitle];
     self.shortName = [aDecoder decodeObjectForKey:kVTPaymentListModelShortName];
    self.localPaymentIdentifier = [aDecoder decodeObjectForKey:kVTPaymentListModelLocalIdentifier];
    self.internalBaseClassDescription = [aDecoder decodeObjectForKey:kVTPaymentListModelDescription];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:_internalBaseClassIdentifier forKey:kVTPaymentListModelId];
    [aCoder encodeObject:_title forKey:kVTPaymentListModelTitle];
    [aCoder encodeObject:_internalBaseClassDescription forKey:kVTPaymentListModelDescription];
}

- (id)copyWithZone:(NSZone *)zone {
    MidtransPaymentListModel *copy = [[MidtransPaymentListModel alloc] init];
    
    if (copy) {
        
        copy.internalBaseClassIdentifier = [self.internalBaseClassIdentifier copyWithZone:zone];
        copy.title = [self.title copyWithZone:zone];
        copy.internalBaseClassDescription = [self.internalBaseClassDescription copyWithZone:zone];
    }
    
    return copy;
}


@end
