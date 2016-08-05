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

@end

@implementation VTTransaction

- (instancetype)initWithPaymentDetails:(id<VTPaymentDetails>)paymentDetails {
    if (self = [super init]) {
        self.paymentDetails = paymentDetails;
    }
    return self;
}

- (NSDictionary *)dictionaryValue {
    return self.paymentDetails.dictionaryValue;
}

- (NSString *)chargeURL {
    return self.paymentDetails.chargeURL;
}

@end
