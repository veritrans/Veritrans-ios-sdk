//
//  MIDPaymentResult.m
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 22/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import "MIDPaymentResult.h"
#import "MIDModelHelper.h"

@implementation MIDPaymentResult

- (NSDictionary *)dictionaryValue {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    [result setValue:self.currency forKey:@"currency"];
    [result setValue:self.deepLinkURL forKey:@"deeplink_url"];
    [result setValue:self.finishRedirectURL forKey:@"finish_redirect_url"];
    [result setValue:self.fraudStatus forKey:@"fraud_status"];
    [result setValue:self.gopayExpiration forKey:@"gopay_expiration"];
    [result setValue:self.gopayExpirationRaw forKey:@"gopay_expiration_raw"];
    [result setValue:self.grossAmount forKey:@"gross_amount"];
    [result setValue:self.orderID forKey:@"order_id"];
    [result setValue:self.paymentType forKey:@"payment_type"];
    [result setValue:self.qrCodeURL forKey:@"qr_code_url"];
    [result setValue:self.statusCode forKey:@"status_code"];
    [result setValue:self.statusMessage forKey:@"status_message"];
    [result setValue:self.transactionID forKey:@"transaction_id"];
    [result setValue:self.transactionStatus forKey:@"transaction_status"];
    [result setValue:self.transactionTime forKey:@"transaction_time"];
    return result;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        self.currency = [dictionary objectOrNilForKey:@"currency"];
        self.deepLinkURL = [dictionary objectOrNilForKey:@"deeplink_url"];
        self.finishRedirectURL = [dictionary objectOrNilForKey:@"finish_redirect_url"];
        self.fraudStatus = [dictionary objectOrNilForKey:@"fraud_status"];
        self.gopayExpiration = [dictionary objectOrNilForKey:@"gopay_expiration"];
        self.gopayExpirationRaw = [dictionary objectOrNilForKey:@"gopay_expiration_raw"];
        self.grossAmount = [dictionary objectOrNilForKey:@"gross_amount"];
        self.orderID = [dictionary objectOrNilForKey:@"order_id"];
        self.paymentType = [dictionary objectOrNilForKey:@"payment_type"];
        self.qrCodeURL = [dictionary objectOrNilForKey:@"qr_code_url"];
        self.statusCode = [dictionary objectOrNilForKey:@"status_code"];
        self.statusMessage = [dictionary objectOrNilForKey:@"status_message"];
        self.transactionID = [dictionary objectOrNilForKey:@"transaction_id"];
        self.transactionStatus = [dictionary objectOrNilForKey:@"transaction_status"];
        self.transactionTime = [dictionary objectOrNilForKey:@"transaction_time"];
    }
    return self;
}

@end
