//
//  MidtransPaymentRequestV2Installment.m
//
//  Created by Zanna Simarmata on 1/3/17
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "MidtransPaymentRequestV2Installment.h"
#import "MidtransPaymentRequestV2Terms.h"


NSString *const kMidtransPaymentRequestV2InstallmentTerms = @"terms";
NSString *const kMidtransPaymentRequestV2InstallmentRequired = @"required";


@interface MidtransPaymentRequestV2Installment ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation MidtransPaymentRequestV2Installment

@synthesize terms = _terms;
@synthesize required = _required;

+ (instancetype)modelWithTerms:(NSDictionary *)terms isRequired:(BOOL)required {
    MidtransPaymentRequestV2Installment *obj = [MidtransPaymentRequestV2Installment new];
    obj.terms = terms;
    obj.required = required;
    return obj;
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
        self.terms = [dict objectForKey:kMidtransPaymentRequestV2InstallmentTerms];
        self.required = [[self objectOrNilForKey:kMidtransPaymentRequestV2InstallmentRequired fromDictionary:dict] boolValue];
        
    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.terms forKey:kMidtransPaymentRequestV2InstallmentTerms];
    [mutableDict setValue:[NSNumber numberWithBool:self.required] forKey:kMidtransPaymentRequestV2InstallmentRequired];
    
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
    
    self.terms = [aDecoder decodeObjectForKey:kMidtransPaymentRequestV2InstallmentTerms];
    self.required = [aDecoder decodeBoolForKey:kMidtransPaymentRequestV2InstallmentRequired];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
    [aCoder encodeObject:_terms forKey:kMidtransPaymentRequestV2InstallmentTerms];
    [aCoder encodeBool:_required forKey:kMidtransPaymentRequestV2InstallmentRequired];
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
