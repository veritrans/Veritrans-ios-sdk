//
//  MTMaskedCreditCard.m
//  iossdk-gojek
//
//  Created by Nanang Rafsanjani on 3/10/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MidtransMaskedCreditCard.h"
#import "MidtransConstant.h"
#import "MidtransCreditCardHelper.h"
#import "MidtransCreditCardConfig.h"

NSString *const kMTMaskedCreditCard = @"masked_card";
NSString *const kMTMaskedCreditCardToken = @"saved_token_id";
NSString *const kSNPMaskedCreditCardStatusCode = @"status_code";
NSString *const kSNPMaskedCreditCardTransactionId = @"transaction_id";

@interface MidtransMaskedCreditCard()
@property (nonatomic, strong) NSString *maskedNumber;
@property (nonatomic, strong) NSString *savedTokenId;
@property (nonatomic,strong) NSString *statusCode;
@property (nonatomic,strong) NSString *transactionId;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *tokenType;
@property (nonatomic, strong) NSString *expiresAt;
@property (nonatomic, strong) NSDictionary *data;
@end

@implementation MidtransMaskedCreditCard

- (instancetype)initWithData:(NSDictionary *)data {
    if (self = [super init]) {
        self.maskedNumber = [data[kMTMaskedCreditCard] stringByReplacingOccurrencesOfString:@"-" withString:@"XXXXXX"];
        self.savedTokenId = data[kMTMaskedCreditCardToken];
        self.expiresAt  = data[kMTMaskedCreditCardExpiresAt];
        self.statusCode = data[kSNPMaskedCreditCardStatusCode];
        self.transactionId = data[kSNPMaskedCreditCardTransactionId];
        self.type = [MidtransCreditCardHelper nameFromString:self.maskedNumber];
        self.data = data;
    }
    return self;
}

- (instancetype _Nonnull)initWithDictionary:(NSDictionary *_Nonnull)dictionary {
    if (self = [super init]) {
        self.savedTokenId = dictionary[kMTMaskedCreditCardIdentifier];
        self.maskedNumber = dictionary[kMTMaskedCreditCardCardhash];
        self.type = dictionary[kMTMaskedCreditCardType]?dictionary[kMTMaskedCreditCardType]:@"";
        self.tokenType = dictionary[kMTMaskedCreditCardTokenType]?dictionary[kMTMaskedCreditCardTokenType]:@"";
        self.expiresAt = dictionary[kMTMaskedCreditCardExpiresAt]?dictionary[kMTMaskedCreditCardExpiresAt]:@"";
        self.statusCode = @"";
        self.transactionId = @"";
    }
    return self;
}
- (instancetype )initWithSavedTokenId:(NSString * _Nonnull)savedTokenId
                         maskedNumber:(NSString * _Nonnull)maskedNumber
                            tokenType:(NSString * _Nullable)tokenType
                            expiresAt:(NSString *_Nullable)expiresAt {
    
    if (self = [super init]) {
        self.maskedNumber = maskedNumber;
        self.savedTokenId = savedTokenId;
        self.expiresAt  = expiresAt;
        self.statusCode = @"";
        self.transactionId = @"";
        self.type = [MidtransCreditCardHelper nameFromString:self.maskedNumber];
    }
    return self;
}
- (NSDictionary *)dictionaryValue {
    return @{kMTMaskedCreditCardIdentifier:self.savedTokenId,
             kMTMaskedCreditCardCardhash:self.maskedNumber,
             kMTMaskedCreditCardExpiresAt:self.expiresAt,
             kMTMaskedCreditCardTokenType:[CC_CONFIG tokenStorageEnabled]?@"two_clicks":@"",
             kSNPMaskedCreditCardStatusCode:self.statusCode,
             kSNPMaskedCreditCardTransactionId:self.transactionId};
}

- (NSString *)description {
    NSData *data = [NSJSONSerialization dataWithJSONObject:self.dictionaryValue options:NSJSONWritingPrettyPrinted error:nil];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end
