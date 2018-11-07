//
//  MidtransPaymentRequestV2SavedTokens.m
//
//  Created by Ratna Kumalasari on 10/25/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "MidtransPaymentRequestV2SavedTokens.h"


NSString *const kMidtransPaymentRequestV2SavedTokensTokenType = @"token_type";
NSString *const kMidtransPaymentRequestV2SavedTokensExpiresAt = @"expires_at";
NSString *const kMidtransPaymentRequestV2SavedTokensMaskedCard = @"masked_card";
NSString *const kMidtransPaymentRequestV2SavedTokensToken = @"token";


@interface MidtransPaymentRequestV2SavedTokens ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation MidtransPaymentRequestV2SavedTokens

@synthesize tokenType = _tokenType;
@synthesize expiresAt = _expiresAt;
@synthesize maskedCard = _maskedCard;
@synthesize token = _token;

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
        self.tokenType = [self objectOrNilForKey:kMidtransPaymentRequestV2SavedTokensTokenType fromDictionary:dict];
        self.expiresAt = [self objectOrNilForKey:kMidtransPaymentRequestV2SavedTokensExpiresAt fromDictionary:dict];
        self.maskedCard = [self objectOrNilForKey:kMidtransPaymentRequestV2SavedTokensMaskedCard fromDictionary:dict];
        self.token = [self objectOrNilForKey:kMidtransPaymentRequestV2SavedTokensToken fromDictionary:dict];
    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.tokenType forKey:kMidtransPaymentRequestV2SavedTokensTokenType];
    [mutableDict setValue:self.expiresAt forKey:kMidtransPaymentRequestV2SavedTokensExpiresAt];
    [mutableDict setValue:self.maskedCard forKey:kMidtransPaymentRequestV2SavedTokensMaskedCard];
    [mutableDict setValue:self.token forKey:kMidtransPaymentRequestV2SavedTokensToken];
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
    
    self.tokenType = [aDecoder decodeObjectForKey:kMidtransPaymentRequestV2SavedTokensTokenType];
    self.expiresAt = [aDecoder decodeObjectForKey:kMidtransPaymentRequestV2SavedTokensExpiresAt];
    self.maskedCard = [aDecoder decodeObjectForKey:kMidtransPaymentRequestV2SavedTokensMaskedCard];
    self.token = [aDecoder decodeObjectForKey:kMidtransPaymentRequestV2SavedTokensToken];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_tokenType forKey:kMidtransPaymentRequestV2SavedTokensTokenType];
    [aCoder encodeObject:_expiresAt forKey:kMidtransPaymentRequestV2SavedTokensExpiresAt];
    [aCoder encodeObject:_maskedCard forKey:kMidtransPaymentRequestV2SavedTokensMaskedCard];
    [aCoder encodeObject:_token forKey:kMidtransPaymentRequestV2SavedTokensToken];
}

- (id)copyWithZone:(NSZone *)zone
{
    MidtransPaymentRequestV2SavedTokens *copy = [[MidtransPaymentRequestV2SavedTokens alloc] init];
    
    if (copy) {
        copy.token = [self.token copyWithZone:zone];
        copy.tokenType = [self.tokenType copyWithZone:zone];
        copy.expiresAt = [self.expiresAt copyWithZone:zone];
        copy.maskedCard = [self.maskedCard copyWithZone:zone];
    }
    
    return copy;
}


@end
