//
//  VTCTransactionDetails.m
//  MidtransCoreKit
//
//  Created by Akbar Taufiq Herlangga on 3/3/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTCTransactionDetails.h"

@interface VTCTransactionDetails()

@property (nonatomic, readwrite) NSString* orderId;
@property (nonatomic, readwrite) NSNumber* grossAmount;

@end

@implementation VTCTransactionDetails

- (instancetype)initWithOrderId:(NSString *)orderId grossAmount:(NSNumber *)grossAmount {
    if (self = [super init]) {
        self.orderId = orderId;
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
