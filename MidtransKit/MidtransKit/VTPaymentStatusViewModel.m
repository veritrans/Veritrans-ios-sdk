//
//  VTPaymentStatusViewModel.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 3/7/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTPaymentStatusViewModel.h"
#import "VTClassHelper.h"

@interface VTPaymentStatusViewModel()

@property (nonatomic) NSString *totalAmount;
@property (nonatomic) NSString *orderId;
@property (nonatomic) NSString *transactionTime;
@property (nonatomic) NSString *paymentType;
@property (nonatomic) NSDictionary *paymentStatusData;

@end

@implementation VTPaymentStatusViewModel

/*
 "transaction_id" => "ca5e0ff5-4297-48ef-aa25-b3ab018d4ead",
 "order_id" => "order52",
 "gross_amount" => "200000.00",
 "payment_type" => "credit_card",
 "transaction_time" => "2014-03-27 17:20:53",
 "transaction_status" => "capture",
 "fraud_status" => "accept",
 "masked_card" => "481111-1114",
 "saved_token_id" => "4011117d16c884-2cc7-4624-b0a8-10273b7f6cc8",
 "saved_token_id_expired_at" => "2024-03-27 17:20:53",
 "status_code" => "200",
 "bank" => "bni",
 "eci" => "05",
 "approval_code" => "140540",
 "status_message" => "Success, Credit Card 3D Secure transaction is successful"
 */

+ (instancetype)viewModelWithData:(NSDictionary *)paymentStatusData {
    VTPaymentStatusViewModel *viewModel = [[VTPaymentStatusViewModel alloc] init];
    viewModel.paymentStatusData = paymentStatusData;
    return viewModel;
}

- (void)setPaymentStatusData:(NSDictionary *)paymentStatusData {
    _paymentStatusData = paymentStatusData;
    
    NSNumberFormatter *nformatter = [NSNumberFormatter new];
    nformatter.numberStyle = NSNumberFormatterDecimalStyle;
    double damount = [paymentStatusData[@"gross_amount"] doubleValue];
    self.totalAmount = [NSString stringWithFormat:@"Rp %@", [nformatter stringFromNumber:@(damount)]];
    
    self.orderId = paymentStatusData[@"order_id"];
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [formatter dateFromString:paymentStatusData[@"transaction_time"]];
    formatter.dateFormat = @"dd/MM/yyyy, HH:mm:ss";
    self.transactionTime = [formatter stringFromDate:date];
    
    NSString *paymentTypeString = [paymentStatusData[@"payment_type"] stringByReplacingOccurrencesOfString:@"_" withString:@" "];
    self.paymentType = [paymentTypeString capitalizedString];
}

@end
