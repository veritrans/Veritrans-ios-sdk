//
//  VTTransactionData.m
//  iossdk-gojek
//
//  Created by Akbar Taufiq Herlangga on 3/3/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTTransaction.h"

@interface VTTransaction()

@property (nonatomic, readwrite) id paymentDetails;
@property (nonatomic, readwrite) TransactionTokenResponse *token;

@end

@implementation VTTransaction

- (instancetype)initWithPaymentDetails:(id<VTPaymentDetails>)paymentDetails
                                 token:(TransactionTokenResponse *)token {
    if (self = [super init]) {
        self.paymentDetails = paymentDetails;
        self.token = token;
    }
    return self;
}

- (NSDictionary *)dictionaryValue {
    // Check for mandatory fields.
    NSAssert(self.paymentDetails, @"Unspecified paymentDetails.");
    NSAssert(self.token.transactionDetails, @"Unspecified transactionDetails.");
    
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    [result setObject:self.token.tokenId forKey:VT_CORE_TRANSACTION_ID];
    [result addEntriesFromDictionary:self.token.customerDetails.snapDictionaryValue];
    [result addEntriesFromDictionary:self.paymentDetails.dictionaryValue];
    
    return result;
}

- (NSString *)chargeURL {
    return self.paymentDetails.chargeURL;
}

- (NSArray *)itemsArrayValue {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [self.token.itemDetails enumerateObjectsUsingBlock:^(VTItemDetail * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [result addObject:[obj dictionaryValue]];
    }];
    return result;
}

@end
