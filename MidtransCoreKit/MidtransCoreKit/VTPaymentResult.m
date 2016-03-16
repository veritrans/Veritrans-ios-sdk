//
//  VTPaymentResult.m
//  MidtransCoreKit
//
//  Created by Akbar Taufiq Herlangga on 3/15/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTPaymentResult.h"

@interface VTPaymentResult()

@property(nonatomic, readwrite) NSInteger statusCode;
@property(nonatomic, readwrite) NSString *statusMessage;
@property(nonatomic, readwrite) NSString *transactionId;
@property(nonatomic, readwrite) NSString *transactionStatus;
@property(nonatomic, readwrite) NSString *orderId;
@property(nonatomic, readwrite) NSString *paymentType;
@property(nonatomic, readwrite) NSDictionary *additionalData;

@end

@implementation VTPaymentResult

- (instancetype)initWithStatusCode:(NSInteger)statusCode statusMessage:(NSString *)statusMessage transactionId:(NSString *)transactionId transactionStatus:(NSString *)transactionStatus orderId:(NSString *)orderId paymentType:(NSString *)paymentType additionalData:(NSDictionary *)additionalData {
    if (self = [super init]) {
        self.statusCode = statusCode;
        self.statusMessage = statusMessage;
        self.transactionId = transactionId;
        self.transactionStatus = transactionStatus;
        self.orderId = orderId;
        self.paymentType = paymentType;
        self.additionalData = additionalData;
    }
    
    return self;
}

@end
