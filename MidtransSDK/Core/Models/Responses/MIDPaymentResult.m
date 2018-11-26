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
    [result setValue:self.finishRedirectURL forKey:@"finish_redirect_url"];
    [result setValue:self.fraudStatus forKey:@"fraud_status"];
    [result setValue:self.grossAmount forKey:@"gross_amount"];
    [result setValue:self.orderID forKey:@"order_id"];
    [result setValue:self.paymentType forKey:@"payment_type"];
    [result setValue:self.statusCode forKey:@"status_code"];
    [result setValue:self.statusMessage forKey:@"status_message"];
    [result setValue:self.transactionID forKey:@"transaction_id"];
    [result setValue:self.transactionStatus forKey:@"transaction_status"];
    [result setValue:self.transactionTime forKey:@"transaction_time"];
    
    [result setValue:self.bcaExpiration forKey:@"bca_expiration"];
    [result setValue:self.bcaVANumber forKey:@"bca_va_number"];
    [result setValue:self.bniExpiration forKey:@"bni_expiration"];
    [result setValue:self.bniVANumber forKey:@"bni_va_number"];
    [result setValue:self.permataExpiration forKey:@"permata_expiration"];
    [result setValue:self.permataVANumber forKey:@"permata_va_number"];
    [result setValue:self.billpaymentExpiration forKey:@"billpayment_expiration"];
    [result setValue:self.billKey forKey:@"bill_key"];
    [result setValue:self.billerCode forKey:@"biller_code"];
    [result setValue:self.pdfURL forKey:@"pdf_url"];
    
    [result setValue:self.deepLinkURL forKey:@"deeplink_url"];
    [result setValue:self.qrCodeURL forKey:@"qr_code_url"];
    [result setValue:self.gopayExpiration forKey:@"gopay_expiration"];
    [result setValue:self.gopayExpirationRaw forKey:@"gopay_expiration_raw"];
    return result;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        self.currency = [dictionary objectOrNilForKey:@"currency"];
        self.finishRedirectURL = [dictionary objectOrNilForKey:@"finish_redirect_url"];
        self.fraudStatus = [dictionary objectOrNilForKey:@"fraud_status"];
        self.grossAmount = [dictionary objectOrNilForKey:@"gross_amount"];
        self.orderID = [dictionary objectOrNilForKey:@"order_id"];
        self.paymentType = [dictionary objectOrNilForKey:@"payment_type"];
        self.statusCode = [dictionary objectOrNilForKey:@"status_code"];
        self.statusMessage = [dictionary objectOrNilForKey:@"status_message"];
        self.transactionID = [dictionary objectOrNilForKey:@"transaction_id"];
        self.transactionStatus = [dictionary objectOrNilForKey:@"transaction_status"];
        self.transactionTime = [dictionary objectOrNilForKey:@"transaction_time"];
        
        self.bcaExpiration = [dictionary objectOrNilForKey:@"bca_expiration"];
        self.bcaVANumber = [dictionary objectOrNilForKey:@"bca_va_number"];
        self.bniExpiration = [dictionary objectOrNilForKey:@"bni_expiration"];
        self.bniVANumber = [dictionary objectOrNilForKey:@"bni_va_number"];
        self.permataExpiration = [dictionary objectOrNilForKey:@"permata_expiration"];
        self.permataVANumber = [dictionary objectOrNilForKey:@"permata_va_number"];
        self.billpaymentExpiration = [dictionary objectOrNilForKey:@"billpayment_expiration"];
        self.billKey = [dictionary objectOrNilForKey:@"bill_key"];
        self.billerCode = [dictionary objectOrNilForKey:@"biller_code"];
        self.pdfURL = [dictionary objectOrNilForKey:@"pdf_url"];
        
        self.gopayExpiration = [dictionary objectOrNilForKey:@"gopay_expiration"];
        self.gopayExpirationRaw = [dictionary objectOrNilForKey:@"gopay_expiration_raw"];
        self.qrCodeURL = [dictionary objectOrNilForKey:@"qr_code_url"];
        self.deepLinkURL = [dictionary objectOrNilForKey:@"deeplink_url"];
    }
    return self;
}

@end
