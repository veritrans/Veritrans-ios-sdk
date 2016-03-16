//
//  VTPaymentResult.m
//  MidtransCoreKit
//
//  Created by Akbar Taufiq Herlangga on 3/15/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTPaymentResult.h"
#import "VTHelper.h"

@interface VTPaymentResult()

@property(nonatomic, readwrite) NSInteger statusCode;
@property(nonatomic, readwrite) NSString *statusMessage;
@property(nonatomic, readwrite) NSString *transactionId;
@property(nonatomic, readwrite) NSString *transactionStatus;
@property(nonatomic, readwrite) NSString *orderId;
@property(nonatomic, readwrite) NSString *paymentType;
@property(nonatomic, readwrite) NSDictionary *additionalData;
@property(nonatomic, readwrite) NSDate *transactionTime;
@property(nonatomic, readwrite) NSNumber *grossAmount;

@end

@implementation VTPaymentResult

- (instancetype)initWithPaymentResponse:(NSDictionary *)response {
    self = [super init];
    if (self) {
        NSMutableDictionary *mResponse = [NSMutableDictionary dictionaryWithDictionary:response];
        self.statusCode = [[mResponse objectThenDeleteForKey:@"status_code"] integerValue];
        self.statusMessage = [mResponse objectThenDeleteForKey:@"status_message"];
        self.transactionId = [mResponse objectThenDeleteForKey:@"transaction_id"];
        self.transactionStatus = [mResponse objectThenDeleteForKey:@"transaction_status"];
        self.orderId = [mResponse objectThenDeleteForKey:@"order_id"];
        self.paymentType = [mResponse objectThenDeleteForKey:@"payment_type"];
        
        id rawGrossAmount = [mResponse objectThenDeleteForKey:@"gross_amount"];
        if (rawGrossAmount) {
            self.grossAmount = @([rawGrossAmount doubleValue]);
        }
        
        id rawTransactionTime = [mResponse objectThenDeleteForKey:@"transaction_time"];
        if (rawTransactionTime) {
            NSDateFormatter *formatter = [NSObject dateFormatterWithIdentifier:@"vt.date"];
            formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
            self.transactionTime = [formatter dateFromString:rawTransactionTime];
        }
        
        self.additionalData = mResponse;
    }
    return self;
}

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
