//
//  VTMaskedCreditCard.m
//  iossdk-gojek
//
//  Created by Nanang Rafsanjani on 3/10/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTMaskedCreditCard.h"

@interface VTMaskedCreditCard()
@property (nonatomic, readwrite) NSString *maskedNumber;
@property (nonatomic, readwrite) NSString *savedTokenId;
@property (nonatomic, readwrite) NSInteger statusCode;
@property (nonatomic, readwrite) NSString *transactionId;
@property (nonatomic, readwrite) NSDictionary *dictionaryValue;
@end

@implementation VTMaskedCreditCard

- (instancetype)initWithData:(NSDictionary *)data {
    if (self = [super init]) {
        self.maskedNumber = [data[@"masked_card"] stringByReplacingOccurrencesOfString:@"-" withString:@"XXXXXX"];
        self.savedTokenId = data[@"saved_token_id"];
        self.statusCode = [data[@"status_code"] integerValue];
        self.transactionId = data[@"transaction_id"];
        self.dictionaryValue = data;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Masked Number: %@\n Saved Token ID: %@", _maskedNumber, _savedTokenId];
}
@end
