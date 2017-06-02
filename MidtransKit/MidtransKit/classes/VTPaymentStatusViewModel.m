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
@property (nonatomic) MidtransTransactionResult *transactionResult;
@end

@implementation VTPaymentStatusViewModel

- (instancetype)initWithTransactionResult:(MidtransTransactionResult *)transactionResult {
    if (self = [super init]) {
        self.transactionResult = transactionResult;
        self.totalAmount = transactionResult.grossAmount.formattedCurrencyNumber;
        self.orderId = transactionResult.orderId;
        self.additionalData = transactionResult.additionalData;
        NSDateFormatter *formatter = [NSObject dateFormatterWithIdentifier:@"vt.date"];
        formatter.dateFormat = @"dd/MM/yyyy, HH:mm:ss";
        self.transactionTime = [formatter stringFromDate:transactionResult.transactionTime];
        NSString *paymentTypeString = [transactionResult.paymentType stringByReplacingOccurrencesOfString:@"_" withString:@" "];
        self.paymentType = [paymentTypeString capitalizedString];
    }
    return self;
}

@end
