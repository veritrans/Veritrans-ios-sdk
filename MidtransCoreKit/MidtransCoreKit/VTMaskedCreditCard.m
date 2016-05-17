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

+ (instancetype)maskedCardFromData:(NSDictionary *)data; {
    VTMaskedCreditCard *card = [VTMaskedCreditCard new];
    card.maskedNumber = [data[@"masked_card"] stringByReplacingOccurrencesOfString:@"-" withString:@"XXXXXX"];
    card.savedTokenId = data[@"saved_token_id"];
    card.statusCode = [data[@"status_code"] integerValue];
    card.transactionId = data[@"transaction_id"];
    card.dictionaryValue = data;
    return card;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Masked Number: %@\n Saved Token ID: %@", _maskedNumber, _savedTokenId];
}
@end
