//
//  VTTransactionDetails.m
//  iossdk-gojek
//
//  Created by Akbar Taufiq Herlangga on 3/3/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MidtransTransactionDetails.h"
#import "MidtransHelper.h"

@interface MidtransTransactionDetails()

@property (nonatomic, readwrite) NSString *orderId;
@property (nonatomic, readwrite) NSNumber *grossAmount;
@property (nonatomic, readwrite) MidtransCurrency currency;

@end

@implementation MidtransTransactionDetails

- (instancetype)initWithOrderID:(NSString *)orderID andGrossAmount:(NSNumber *)grossAmount {
    if (self = [super init]) {
        self.orderId = orderID;
        self.grossAmount = grossAmount;
    }
    return self;
}

-(instancetype)initWithOrderID:(NSString *)orderID andGrossAmount:(NSNumber *)grossAmount andCurrency:(MidtransCurrency)currency {
    if (self = [super init]) {
        self.orderId = orderID;
        self.grossAmount = grossAmount;
        self.currency = currency;
    }
    return self;
}

- (NSDictionary *)dictionaryValue {
    // Format MUST BE compatible with
    // http://docs.veritrans.co.id/en/api/methods.html#transaction_details_attr
    NSInteger grossAmount = [self.grossAmount integerValue];
    return @{@"order_id": self.orderId,
             @"gross_amount": [NSNumber numberWithInteger:grossAmount],
             @"currency": [MidtransHelper stringFromCurrency:self.currency]
             };
}

@end
