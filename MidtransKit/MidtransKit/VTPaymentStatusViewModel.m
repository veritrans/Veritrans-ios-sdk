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
@property (nonatomic) VTTransactionResult *paymentResult;

@end

@implementation VTPaymentStatusViewModel

+ (instancetype)viewModelWithPaymentResult:(VTTransactionResult *)paymentResult {
    VTPaymentStatusViewModel *viewModel = [[VTPaymentStatusViewModel alloc] init];
    viewModel.paymentResult = paymentResult;
    return viewModel;
}

- (void)setPaymentResult:(VTTransactionResult *)paymentResult {
    _paymentResult = paymentResult;
    
    NSNumberFormatter *nformatter = [NSObject indonesianCurrencyFormatter];
    self.totalAmount = [nformatter stringFromNumber:paymentResult.grossAmount];
    
    self.orderId = paymentResult.orderId;
    
    NSDateFormatter *formatter = [NSObject dateFormatterWithIdentifier:@"vt.date"];
    formatter.dateFormat = @"dd/MM/yyyy, HH:mm:ss";
    self.transactionTime = [formatter stringFromDate:paymentResult.transactionTime];
    
    NSString *paymentTypeString = [paymentResult.paymentType stringByReplacingOccurrencesOfString:@"_" withString:@" "];
    self.paymentType = [paymentTypeString capitalizedString];
}

@end
