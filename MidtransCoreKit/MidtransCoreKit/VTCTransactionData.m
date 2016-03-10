//
//  VTCTransactionData.m
//  MidtransCoreKit
//
//  Created by Akbar Taufiq Herlangga on 3/3/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTCTransactionData.h"
#import "VTCPaymentBankTransfer.h"

@interface VTCTransactionData()

@property (nonatomic, readwrite) id paymentDetails;
@property (nonatomic, readwrite) VTCTransactionDetails *transactionDetails;
@property (nonatomic, readwrite) VTCCustomerDetails *customerDetails;
@property (nonatomic, readwrite) NSArray<VTItem*> *itemDetails;

@end

@implementation VTCTransactionData

- (instancetype)initWithpaymentDetails:(id<VTCPaymentDetails>)paymentDetails transactionDetails:(VTCTransactionDetails *)transactionDetails customerDetails:(VTCCustomerDetails *)customerDetails itemDetails:(NSArray<VTItem *> *)itemDetails {
    if (self = [super init]) {
        self.paymentDetails = paymentDetails;
        self.transactionDetails = transactionDetails;
        self.customerDetails = customerDetails;
        self.itemDetails = itemDetails;
    }
    return self;
}

- (NSDictionary *)dictionaryValue {
    NSDictionary *result = @{@"payment_type": [self.paymentDetails paymentType],
                             @"transaction_details": [self.transactionDetails dictionaryValue],
                             @"item_details": [self itemsArrayValue],
                             @"customer_details": [self.customerDetails dictionaryValue],
                             // This last pair below exploit the fact that the JSON described in
                             // http://docs.veritrans.co.id/en/api/methods.html#Charge
                             // MUST HAVE key with the same name with the value of "payment_type".
                             // For example, when the "payment_type" value is "bank_transfer",
                             // the JSON MUST HAVE key named "bank_transfer", too.
                             [self.paymentDetails paymentType]: [self.paymentDetails dictionaryValue]};
    return result;
}

- (NSArray *)itemsArrayValue {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [self.itemDetails enumerateObjectsUsingBlock:^(VTItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [result addObject:[obj requestData]];
    }];
    return result;
}

@end
