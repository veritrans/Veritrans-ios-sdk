//
//  Snapresponse.m
//
//  Created by Arie  on 7/19/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "MidtransTransactionTokenResponse.h"

NSString *const kSnapresponseToken = @"token";
NSString *const kSnapresponseTokenId = @"token_id";

@interface MidtransTransactionTokenResponse ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation MidtransTransactionTokenResponse

@synthesize tokenId = _tokenId;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict transactionDetails:(MidtransTransactionDetails *)transactionDetails customerDetails:(MidtransCustomerDetails *)customerDetails itemDetails:(NSArray <MidtransItemDetail*>*)itemDetails {
    MidtransTransactionTokenResponse *response = [self modelObjectWithDictionary:dict];
    response.transactionDetails = transactionDetails;
    response.customerDetails = customerDetails;
    response.itemDetails = itemDetails;
    return response;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
        self.tokenId = [self objectOrNilForKey:kSnapresponseToken fromDictionary:dict]?[self objectOrNilForKey:kSnapresponseToken fromDictionary:dict]:[self objectOrNilForKey:kSnapresponseTokenId fromDictionary:dict];
    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.tokenId forKey:kSnapresponseToken];
    
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
    
    self.tokenId = [aDecoder decodeObjectForKey:kSnapresponseToken];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:_tokenId forKey:kSnapresponseToken];
}

- (id)copyWithZone:(NSZone *)zone {
    MidtransTransactionTokenResponse *copy = [[MidtransTransactionTokenResponse alloc] init];
    if (copy) {
        
        copy.tokenId = [self.tokenId copyWithZone:zone];
    }
    
    return copy;
}


@end
