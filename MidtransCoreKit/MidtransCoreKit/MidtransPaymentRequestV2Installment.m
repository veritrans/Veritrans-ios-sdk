//
//  Installment.m
//
//  Created by Ratna Kumalasari on 11/23/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "MidtransPaymentRequestV2Installment.h"



NSString *const kInstallmentTerms = @"terms";
NSString *const kInstallmentRequired = @"required";


@interface MidtransPaymentRequestV2Installment ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation MidtransPaymentRequestV2Installment

@synthesize terms = _terms;
@synthesize required = _required;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
        self.terms =[self objectOrNilForKey:kInstallmentTerms fromDictionary:dict];
            self.required = [[self objectOrNilForKey:kInstallmentRequired fromDictionary:dict] boolValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.terms forKey:kInstallmentTerms];
    [mutableDict setValue:[NSNumber numberWithBool:self.required] forKey:kInstallmentRequired];

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

    self.terms = [aDecoder decodeObjectForKey:kInstallmentTerms];
    self.required = [aDecoder decodeBoolForKey:kInstallmentRequired];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_terms forKey:kInstallmentTerms];
    [aCoder encodeBool:_required forKey:kInstallmentRequired];
}

- (id)copyWithZone:(NSZone *)zone
{
    MidtransPaymentRequestV2Installment *copy = [[MidtransPaymentRequestV2Installment alloc] init];
    
    if (copy) {

        copy.terms = [self.terms copyWithZone:zone];
        copy.required = self.required;
    }
    
    return copy;
}


@end
