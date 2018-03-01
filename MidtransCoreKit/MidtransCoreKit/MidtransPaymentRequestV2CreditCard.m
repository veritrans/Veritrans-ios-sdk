//
//  MidtransPaymentRequestV2CreditCard.m
//
//  Created by Ratna Kumalasari on 10/25/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "MidtransPaymentRequestV2CreditCard.h"
#import "MidtransPaymentRequestV2SavedTokens.h"
#import "MidtransPaymentRequestV2Installment.h"

NSString *const kMidtransPaymentRequestV2CreditCardSavedTokens = @"saved_tokens";
NSString *const kMidtransPaymentRequestV2CreditCardWhitelistBins = @"whitelist_bins";
NSString  *const kMidtransPaymentRequestV2CreditCardBlackListBins = @"blacklist_bins";
NSString *const kMidtransPaymentRequestV2CreditCardSaveCard = @"save_card";
NSString *const kMidtransPaymentRequestV2CreditCardSecure = @"secure";
NSString *const kMidtransPaymentRequestV2CreditCardInstallments = @"installment";


@interface MidtransPaymentRequestV2CreditCard ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation MidtransPaymentRequestV2CreditCard

@synthesize savedTokens = _savedTokens;
@synthesize whitelistBins = _whitelistBins;
@synthesize saveCard = _saveCard;
@synthesize secure = _secure;
@synthesize installments  =_installments;


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
    NSObject *receivedMidtransPaymentRequestV2SavedTokens = [dict objectForKey:kMidtransPaymentRequestV2CreditCardSavedTokens];
    NSMutableArray *parsedMidtransPaymentRequestV2SavedTokens = [NSMutableArray array];
    if ([receivedMidtransPaymentRequestV2SavedTokens isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedMidtransPaymentRequestV2SavedTokens) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedMidtransPaymentRequestV2SavedTokens addObject:[MidtransPaymentRequestV2SavedTokens modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedMidtransPaymentRequestV2SavedTokens isKindOfClass:[NSDictionary class]]) {
       [parsedMidtransPaymentRequestV2SavedTokens addObject:[MidtransPaymentRequestV2SavedTokens modelObjectWithDictionary:(NSDictionary *)receivedMidtransPaymentRequestV2SavedTokens]];
    }
        self.installments = [MidtransPaymentRequestV2Installment modelObjectWithDictionary:[dict objectForKey:kMidtransPaymentRequestV2CreditCardInstallments]];
    self.savedTokens = [NSArray arrayWithArray:parsedMidtransPaymentRequestV2SavedTokens];
            self.whitelistBins = [self objectOrNilForKey:kMidtransPaymentRequestV2CreditCardWhitelistBins fromDictionary:dict];
        self.blacklistBins = [self objectOrNilForKey:kMidtransPaymentRequestV2CreditCardBlackListBins fromDictionary:dict];
            self.saveCard = [[self objectOrNilForKey:kMidtransPaymentRequestV2CreditCardSaveCard fromDictionary:dict] boolValue];
            self.secure = [[self objectOrNilForKey:kMidtransPaymentRequestV2CreditCardSecure fromDictionary:dict] boolValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    NSMutableArray *tempArrayForSavedTokens = [NSMutableArray array];
    for (NSObject *subArrayObject in self.savedTokens) {
        if ([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForSavedTokens addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForSavedTokens addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForSavedTokens] forKey:kMidtransPaymentRequestV2CreditCardSavedTokens];
    NSMutableArray *tempArrayForWhitelistBins = [NSMutableArray array];
    for (NSObject *subArrayObject in self.whitelistBins) {
        if ([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForWhitelistBins addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForWhitelistBins addObject:subArrayObject];
        }
    }
    
    NSMutableArray *tempArrayForBlackListBins = [NSMutableArray array];
    for (NSObject *subArrayObject in self.blacklistBins) {
        if ([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForBlackListBins addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForBlackListBins addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[self.installments dictionaryRepresentation] forKey:kMidtransPaymentRequestV2CreditCardInstallments];
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForWhitelistBins] forKey:kMidtransPaymentRequestV2CreditCardWhitelistBins];
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForBlackListBins] forKey:kMidtransPaymentRequestV2CreditCardBlackListBins];
    [mutableDict setValue:[NSNumber numberWithBool:self.saveCard] forKey:kMidtransPaymentRequestV2CreditCardSaveCard];
    [mutableDict setValue:[NSNumber numberWithBool:self.secure] forKey:kMidtransPaymentRequestV2CreditCardSecure];

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

    self.savedTokens = [aDecoder decodeObjectForKey:kMidtransPaymentRequestV2CreditCardSavedTokens];
    self.whitelistBins = [aDecoder decodeObjectForKey:kMidtransPaymentRequestV2CreditCardWhitelistBins];
    self.saveCard = [aDecoder decodeBoolForKey:kMidtransPaymentRequestV2CreditCardSaveCard];
    self.blacklistBins =  [aDecoder decodeObjectForKey:kMidtransPaymentRequestV2CreditCardBlackListBins];
    self.secure = [aDecoder decodeBoolForKey:kMidtransPaymentRequestV2CreditCardSecure];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_savedTokens forKey:kMidtransPaymentRequestV2CreditCardSavedTokens];
    [aCoder encodeObject:_whitelistBins forKey:kMidtransPaymentRequestV2CreditCardWhitelistBins];
    [aCoder encodeBool:_saveCard forKey:kMidtransPaymentRequestV2CreditCardSaveCard];
    [aCoder encodeBool:_secure forKey:kMidtransPaymentRequestV2CreditCardSecure];
}

- (id)copyWithZone:(NSZone *)zone
{
    MidtransPaymentRequestV2CreditCard *copy = [[MidtransPaymentRequestV2CreditCard alloc] init];
    
    if (copy) {

        copy.savedTokens = [self.savedTokens copyWithZone:zone];
        copy.whitelistBins = [self.whitelistBins copyWithZone:zone];
        copy.saveCard = self.saveCard;
        copy.secure = self.secure;
    }
    
    return copy;
}


@end
