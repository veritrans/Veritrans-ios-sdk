//
//  VTMaskedCreditCard.m
//  iossdk-gojek
//
//  Created by Nanang Rafsanjani on 3/10/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTMaskedCreditCard.h"
#import "VTConstant.h"
#import "VTCreditCardHelper.h"

NSString *const kVTMaskedCreditCard = @"masked_card";
NSString *const kVTMaskedCreditCardToken = @"saved_token_id";

NSString *const kVTMaskedCreditCardTokenIdentifier = @"token_id";
NSString *const kVTMaskedCreditCardTokenCardhash = @"cardhash";
NSString *const kVTMaskedCreditCardTokenType = @"type";

@interface VTMaskedCreditCard()
@property (nonatomic, readwrite) NSString *maskedNumber;
@property (nonatomic, readwrite) NSString *savedTokenId;
@property (nonatomic, readwrite) NSString *type;
@property (nonatomic, readwrite) NSDictionary *data;
@end

@implementation VTMaskedCreditCard

- (instancetype)initWithData:(NSDictionary *)data {
    if (self = [super init]) {
        self.maskedNumber = [data[kVTMaskedCreditCard] stringByReplacingOccurrencesOfString:@"-" withString:@"XXXXXX"];
        self.savedTokenId = data[kVTMaskedCreditCardToken];
        self.type = [VTCreditCardHelper nameFromString:self.maskedNumber];
        self.data = data;
    }
    return self;
}

- (instancetype _Nonnull)initWithDictionary:(NSDictionary *_Nonnull)dictionary {
    if (self = [super init]) {
        self.savedTokenId = dictionary[kVTMaskedCreditCardTokenIdentifier];
        self.maskedNumber = dictionary[kVTMaskedCreditCardTokenCardhash];
        self.type = dictionary[kVTMaskedCreditCardTokenType];
    }
    return self;
}

- (NSDictionary *)dictionaryValue {
    return @{kVTMaskedCreditCardTokenIdentifier:self.savedTokenId,
             kVTMaskedCreditCardTokenCardhash:self.maskedNumber,
             kVTMaskedCreditCardTokenType:self.type};
}

- (NSString *)description {
    NSData *data = [NSJSONSerialization dataWithJSONObject:self.dictionaryValue options:NSJSONWritingPrettyPrinted error:nil];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end
