//
//  MTTransactionResult.m
//  iossdk-gojek
//
//  Created by Akbar Taufiq Herlangga on 3/15/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MidtransTransactionResult.h"
#import "MidtransHelper.h"

@interface MidtransTransactionResult()

@property (nonatomic, readwrite) NSInteger statusCode;
@property (nonatomic, readwrite) NSString *statusMessage;
@property (nonatomic, readwrite) NSString *transactionId;
@property (nonatomic, readwrite) NSString *transactionStatus;
@property (nonatomic, readwrite) NSString *orderId;
@property (nonatomic, readwrite) NSString *paymentType;
@property (nonatomic, readwrite) NSDictionary *additionalData;
@property (nonatomic, readwrite) NSDate *transactionTime;
@property (nonatomic, readwrite) NSNumber *grossAmount;
@property (nonatomic, readwrite) NSString *indomaretPaymentCode;
@property (nonatomic, readwrite) NSString *alfamartExpireTime;
@property (nonatomic, readwrite) NSString *kiosonExpireTime;
@property (nonatomic, readwrite) NSString *mandiriBillpayCode;
@property (nonatomic, readwrite) NSString *qrcodeUrl;
@property (nonatomic, readwrite) NSString *deeplinkUrl;
@property (nonatomic, readwrite) NSString *mandiriBillpayCompanyCode;
@property (nonatomic, readwrite) NSString *virtualAccountNumber;
@property (nonatomic, readwrite) NSURL *redirectURL;

@end

@implementation MidtransTransactionResult

- (instancetype)initWithTransactionResponse:(NSDictionary *)response {
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
        
        if (response[@"saved_token_id" ]) {
            NSDictionary *maskedCardObject = @{@"masked_card":response[@"masked_card"],
                                               @"saved_token_id":response[@"saved_token_id"],
                                               @"status_code":response[@"status_code"],
                                               @"transaction_id":response[@"transaction_id"]};
            _maskedCreditCard = [[MidtransMaskedCreditCard alloc] initWithData:maskedCardObject];
        }
        if (response[@"kioson_expire_time"]) {
             self.kiosonExpireTime = response[@"kioson_expire_time"];
        }
        if (response[@"alfamart_expire_time"]) {
            self.alfamartExpireTime = response[@"alfamart_expire_time"];
        }
        if (response[@"payment_code"]) {
            self.indomaretPaymentCode = response[@"payment_code"];
        }
        
        if (response[@"bill_key"]) {
            self.mandiriBillpayCode = response[@"bill_key"];
            self.mandiriBillpayCompanyCode = response[@"biller_code"];
        }
        
        if (response[@"va_numbers"]) {
            NSDictionary *vaData = response[@"va_numbers"][0];
            self.virtualAccountNumber = vaData[@"va_number"];
        }
        if (response[@"qr_code_url"]) {
            self.qrcodeUrl = response[@"qr_code_url"];
        }
        if (response[@"deeplink_url"]) {
            self.deeplinkUrl = response[@"deeplink_url"];
        }
        if (response[@"permata_va_number"]) {
            self.virtualAccountNumber = response[@"permata_va_number"];
        }
        
        if (response[@"redirect_url"]) {
            self.redirectURL = [NSURL URLWithString:response[@"redirect_url"]];
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

- (NSString *)description {
    return [NSString stringWithFormat:@"statusCode = %li\nstatusMessage = %@\ntransactionId = %@\ntransactionStatus = %@\norderId = %@\npaymentType = %@\ngrossAmount = %@\ntransactionTime = %@\nadditionalData = %@\n", (long)self.statusCode, self.statusMessage, self.transactionId, self.transactionStatus, self.orderId, self.paymentType, self.grossAmount, self.transactionTime, self.additionalData];
}

- (NSString *)codeForLocalization {
    switch (self.statusCode) {
        case 200:
            return @"error_200";
            break;
        case 201:
            return @"error_201";
            break;
        case 202:
            return @"error_202";
            break;
        case 400:
            return @"error_400";
            break;
        case 502:
            return @"error_502";
            break;
        case 406:
            return @"error_406";
            break;
        case 407:
            return @"error_407";
            break;
        case 500:
            return @"error_500";
            break;
        default:
            return @"error_others";
            break;
    }
}

@end
