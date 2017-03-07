//
//  SNPPointResponse.m
//
//  Created by Zanna Simarmata on 3/7/17
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "SNPPointResponse.h"


NSString *const kSNPPointResponseValidationMessages = @"validation_messages";
NSString *const kSNPPointResponsePointBalance = @"point_balance";
NSString *const kSNPPointResponseStatusMessage = @"status_message";
NSString *const kSNPPointResponseStatusCode = @"status_code";
NSString *const kSNPPointResponseTransactionTime = @"transaction_time";
NSString *const kSNPPointResponsePointBalanceAmount = @"point_balance_amount";


@interface SNPPointResponse ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation SNPPointResponse

@synthesize validationMessages = _validationMessages;
@synthesize pointBalance = _pointBalance;
@synthesize statusMessage = _statusMessage;
@synthesize statusCode = _statusCode;
@synthesize transactionTime = _transactionTime;
@synthesize pointBalanceAmount = _pointBalanceAmount;


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
            self.validationMessages = [self objectOrNilForKey:kSNPPointResponseValidationMessages fromDictionary:dict];
            self.pointBalance = [[self objectOrNilForKey:kSNPPointResponsePointBalance fromDictionary:dict] doubleValue];
            self.statusMessage = [self objectOrNilForKey:kSNPPointResponseStatusMessage fromDictionary:dict];
            self.statusCode = [self objectOrNilForKey:kSNPPointResponseStatusCode fromDictionary:dict];
            self.transactionTime = [self objectOrNilForKey:kSNPPointResponseTransactionTime fromDictionary:dict];
            self.pointBalanceAmount = [self objectOrNilForKey:kSNPPointResponsePointBalanceAmount fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    NSMutableArray *tempArrayForValidationMessages = [NSMutableArray array];
    for (NSObject *subArrayObject in self.validationMessages) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForValidationMessages addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForValidationMessages addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForValidationMessages] forKey:kSNPPointResponseValidationMessages];
    [mutableDict setValue:[NSNumber numberWithDouble:self.pointBalance] forKey:kSNPPointResponsePointBalance];
    [mutableDict setValue:self.statusMessage forKey:kSNPPointResponseStatusMessage];
    [mutableDict setValue:self.statusCode forKey:kSNPPointResponseStatusCode];
    [mutableDict setValue:self.transactionTime forKey:kSNPPointResponseTransactionTime];
    [mutableDict setValue:self.pointBalanceAmount forKey:kSNPPointResponsePointBalanceAmount];

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

    self.validationMessages = [aDecoder decodeObjectForKey:kSNPPointResponseValidationMessages];
    self.pointBalance = [aDecoder decodeDoubleForKey:kSNPPointResponsePointBalance];
    self.statusMessage = [aDecoder decodeObjectForKey:kSNPPointResponseStatusMessage];
    self.statusCode = [aDecoder decodeObjectForKey:kSNPPointResponseStatusCode];
    self.transactionTime = [aDecoder decodeObjectForKey:kSNPPointResponseTransactionTime];
    self.pointBalanceAmount = [aDecoder decodeObjectForKey:kSNPPointResponsePointBalanceAmount];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_validationMessages forKey:kSNPPointResponseValidationMessages];
    [aCoder encodeDouble:_pointBalance forKey:kSNPPointResponsePointBalance];
    [aCoder encodeObject:_statusMessage forKey:kSNPPointResponseStatusMessage];
    [aCoder encodeObject:_statusCode forKey:kSNPPointResponseStatusCode];
    [aCoder encodeObject:_transactionTime forKey:kSNPPointResponseTransactionTime];
    [aCoder encodeObject:_pointBalanceAmount forKey:kSNPPointResponsePointBalanceAmount];
}

- (id)copyWithZone:(NSZone *)zone
{
    SNPPointResponse *copy = [[SNPPointResponse alloc] init];
    
    if (copy) {

        copy.validationMessages = [self.validationMessages copyWithZone:zone];
        copy.pointBalance = self.pointBalance;
        copy.statusMessage = [self.statusMessage copyWithZone:zone];
        copy.statusCode = [self.statusCode copyWithZone:zone];
        copy.transactionTime = [self.transactionTime copyWithZone:zone];
        copy.pointBalanceAmount = [self.pointBalanceAmount copyWithZone:zone];
    }
    
    return copy;
}


@end
