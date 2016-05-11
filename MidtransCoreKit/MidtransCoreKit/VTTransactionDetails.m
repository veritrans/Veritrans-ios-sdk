//
//  VTTransactionDetails.m
//  iossdk-gojek
//
//  Created by Akbar Taufiq Herlangga on 3/3/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTTransactionDetails.h"
#import "VTHelper.h"

@interface VTTransactionDetails()

@property (nonatomic, readwrite) NSString* orderId;
@property (nonatomic, readwrite) NSNumber* grossAmount;

@end

@implementation VTTransactionDetails

- (instancetype)initWithOrderID:(NSString *)orderID andGrossAmount:(NSNumber *)grossAmount {
    if (self = [super init]) {
        self.orderId = orderID;
        self.grossAmount = grossAmount;
    }
    return self;
}

- (NSDictionary *)dictionaryValue {
    // Format MUST BE compatible with
    // http://docs.veritrans.co.id/en/api/methods.html#transaction_details_attr
    
    return @{@"order_id": self.orderId,
             @"gross_amount": [self.grossAmount stringValue]};
}

@end
