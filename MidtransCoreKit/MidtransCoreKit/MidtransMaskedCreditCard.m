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

NSString *const kMTMaskedCreditCard = @"masked_card";
NSString *const kMTMaskedCreditCardToken = @"saved_token_id";

NSString *const kMTMaskedCreditCardTokenIdentifier = @"token_id";
NSString *const kMTMaskedCreditCardTokenCardhash = @"cardhash";
NSString *const kMTMaskedCreditCardTokenType = @"type";

@interface MidtransMaskedCreditCard()
@property (nonatomic, readwrite) NSString *maskedNumber;
@property (nonatomic, readwrite) NSString *savedTokenId;
@property (nonatomic, readwrite) NSString *type;
@property (nonatomic, readwrite) NSDictionary *data;
@end

@implementation MidtransMaskedCreditCard

- (instancetype)initWithData:(NSDictionary *)data {
    if (self = [super init]) {
        self.maskedNumber = [data[kMTMaskedCreditCard] stringByReplacingOccurrencesOfString:@"-" withString:@"XXXXXX"];
        self.savedTokenId = data[kMTMaskedCreditCardToken];
        self.type = [MidtransCreditCardHelper nameFromString:self.maskedNumber];
        self.data = data;
    }
    return self;
}

- (instancetype _Nonnull)initWithDictionary:(NSDictionary *_Nonnull)dictionary {
    if (self = [super init]) {
        self.savedTokenId = dictionary[kMTMaskedCreditCardTokenIdentifier];
        self.maskedNumber = dictionary[kMTMaskedCreditCardTokenCardhash];
        self.type = dictionary[kMTMaskedCreditCardTokenType];
    }
    return self;
}

- (NSDictionary *)dictionaryValue {
    return @{kMTMaskedCreditCardTokenIdentifier:self.savedTokenId,
             kMTMaskedCreditCardTokenCardhash:self.maskedNumber,
             kMTMaskedCreditCardTokenType:self.type};
}

- (NSString *)description {
    NSData *data = [NSJSONSerialization dataWithJSONObject:self.dictionaryValue options:NSJSONWritingPrettyPrinted error:nil];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end
