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
@property (nonatomic, readwrite) VTTransactionDetails *transactionDetails;
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
    NSAssert(self.transactionDetails, @"Unspecified transactionDetails.");
    
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    
    // Fill-in mandatory fields.
    [result setValue:[self.transactionDetails dictionaryValue] forKey:@"transaction_details"];
    [result setValue:[self.paymentDetails paymentType] forKey:@"payment_type"];
    if ([self.paymentDetails dictionaryValue]) {
        [result setValue:[self.paymentDetails dictionaryValue] forKey:[self.paymentDetails paymentType]];
    }
    
    // Fill-in optional fields.
    if (self.token.customerDetails) {
        [result setValue:[self.token.customerDetails dictionaryValue] forKey:@"customer_details"];
    }
    if (self.token.itemDetails) {
        [result setValue:[self itemsArrayValue] forKey:@"item_details"];
    }
    if (self.customField1) {
        [result setValue:self.customField1 forKey:@"custom_field1"];
    }
    if (self.customField2) {
        [result setValue:self.customField2 forKey:@"custom_field2"];
    }
    if (self.customField3) {
        [result setValue:self.customField3 forKey:@"custom_field3"];
    }
    
    return result;
}

- (NSArray *)itemsArrayValue {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [self.token.itemDetails enumerateObjectsUsingBlock:^(VTItemDetail * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [result addObject:[obj dictionaryValue]];
    }];
    return result;
}

@end
