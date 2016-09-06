//
//  MidtransMaskedCreditCard.m
//  iossdk-gojek
//
//  Created by Nanang Rafsanjani on 3/10/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MidtransMaskedCreditCard.h"
#import "VTConstant.h"
#import "MidtransCreditCardHelper.h"

NSString *const kMidtransMaskedCreditCard = @"masked_card";
NSString *const kMidtransMaskedCreditCardToken = @"saved_token_id";

NSString *const kMidtransMaskedCreditCardTokenIdentifier = @"token_id";
NSString *const kMidtransMaskedCreditCardTokenCardhash = @"cardhash";
NSString *const kMidtransMaskedCreditCardTokenType = @"type";

@interface MidtransMaskedCreditCard()
@property (nonatomic, readwrite) NSString *maskedNumber;
@property (nonatomic, readwrite) NSString *savedTokenId;
@property (nonatomic, readwrite) NSString *type;
@property (nonatomic, readwrite) NSDictionary *data;
@end

@implementation MidtransMaskedCreditCard

- (instancetype)initWithData:(NSDictionary *)data {
    if (self = [super init]) {
        self.maskedNumber = [data[kMidtransMaskedCreditCard] stringByReplacingOccurrencesOfString:@"-" withString:@"XXXXXX"];
        self.savedTokenId = data[kMidtransMaskedCreditCardToken];
        self.type = [MidtransCreditCardHelper nameFromString:self.maskedNumber];
        self.data = data;
    }
    return self;
}

- (instancetype _Nonnull)initWithDictionary:(NSDictionary *_Nonnull)dictionary {
    if (self = [super init]) {
        self.savedTokenId = dictionary[kMidtransMaskedCreditCardTokenIdentifier];
        self.maskedNumber = dictionary[kMidtransMaskedCreditCardTokenCardhash];
        self.type = dictionary[kMidtransMaskedCreditCardTokenType];
    }
    return self;
}

- (NSDictionary *)dictionaryValue {
    return @{kMidtransMaskedCreditCardTokenIdentifier:self.savedTokenId,
             kMidtransMaskedCreditCardTokenCardhash:self.maskedNumber,
             kMidtransMaskedCreditCardTokenType:self.type};
}

- (NSString *)description {
    NSData *data = [NSJSONSerialization dataWithJSONObject:self.dictionaryValue options:NSJSONWritingPrettyPrinted error:nil];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end
