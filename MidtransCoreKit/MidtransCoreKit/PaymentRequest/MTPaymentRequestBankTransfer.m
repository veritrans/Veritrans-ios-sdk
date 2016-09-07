//
//  PaymentRequestBankTransfer.m
//
//  Created by Arie  on 7/19/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "MTPaymentRequestBankTransfer.h"


NSString *const kPaymentRequestBankTransferBanks = @"banks";


@interface MTPaymentRequestBankTransfer ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation MTPaymentRequestBankTransfer

@synthesize banks = _banks;


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
            self.banks = [self objectOrNilForKey:kPaymentRequestBankTransferBanks fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    NSMutableArray *tempArrayForBanks = [NSMutableArray array];
    for (NSObject *subArrayObject in self.banks) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForBanks addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForBanks addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForBanks] forKey:kPaymentRequestBankTransferBanks];

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

    self.banks = [aDecoder decodeObjectForKey:kPaymentRequestBankTransferBanks];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_banks forKey:kPaymentRequestBankTransferBanks];
}

- (id)copyWithZone:(NSZone *)zone
{
    MTPaymentRequestBankTransfer *copy = [[MTPaymentRequestBankTransfer alloc] init];
    
    if (copy) {

        copy.banks = [self.banks copyWithZone:zone];
    }
    
    return copy;
}


@end
