//
//  VTMaskedCreditCard.m
//  iossdk-gojek
//
//  Created by Nanang Rafsanjani on 3/10/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTMaskedCreditCard.h"
#import "VTConstant.h"
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
        self.savedTokenId = data[VT_CORE_SAVED_ID_TOKEN];
        self.statusCode = [data[VT_CORE_STATUS_CODE] integerValue];
        self.transactionId = data[@"transaction_id"];
        self.dictionaryValue = data;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Masked Number: %@\n Saved Token ID: %@", _maskedNumber, _savedTokenId];
}
@end
