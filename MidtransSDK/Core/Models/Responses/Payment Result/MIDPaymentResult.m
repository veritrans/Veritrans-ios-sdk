//
//  MIDPaymentResult.m
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 22/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import "MIDPaymentResult.h"

@implementation MIDPaymentResult

- (NSDictionary *)dictionaryValue {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    [result setValue:self.currency forKey:@"currency"];
    [result setValue:self.finishRedirectURL forKey:@"finish_redirect_url"];
    [result setValue:self.fraudStatus forKey:@"fraud_status"];
    [result setValue:self.grossAmount forKey:@"gross_amount"];
    [result setValue:self.orderID forKey:@"order_id"];
    [result setValue:[NSString stringFromPaymentMethod:self.paymentMethod] forKey:@"payment_type"];
    [result setValue:@(self.statusCode) forKey:@"status_code"];
    [result setValue:self.statusMessage forKey:@"status_message"];
    [result setValue:self.transactionID forKey:@"transaction_id"];
    [result setValue:self.transactionStatus forKey:@"transaction_status"];
    [result setValue:[self dateToString:self.transactionTime] forKey:@"transaction_time"];

    [result setValue:self.pdfURL forKey:@"pdf_url"];
    return result;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        self.currency = [dictionary objectOrNilForKey:@"currency"];
        self.finishRedirectURL = [dictionary objectOrNilForKey:@"finish_redirect_url"];
        self.fraudStatus = [dictionary objectOrNilForKey:@"fraud_status"];
        self.grossAmount = [[dictionary objectOrNilForKey:@"gross_amount"] toNumber];
        self.orderID = [dictionary objectOrNilForKey:@"order_id"];
        self.paymentMethod = [[dictionary objectOrNilForKey:@"payment_type"] paymentMethod];
        self.statusCode = [[dictionary objectOrNilForKey:@"status_code"] integerValue];
        self.statusMessage = [dictionary objectOrNilForKey:@"status_message"];
        self.transactionID = [dictionary objectOrNilForKey:@"transaction_id"];
        self.transactionStatus = [dictionary objectOrNilForKey:@"transaction_status"];
        self.transactionTime = [self stringToDate:[dictionary objectOrNilForKey:@"transaction_time"]];

        self.pdfURL = [dictionary objectOrNilForKey:@"pdf_url"];
    }
    return self;
}

- (NSString *)dateToString:(NSDate *)date {
    NSDateFormatter *df = [NSDateFormatter new];
    df.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [df stringFromDate:date];
}

- (NSDate *)stringToDate:(NSString *)string {
    NSDateFormatter *df = [NSDateFormatter new];
    df.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [df dateFromString:string];
}

@end
