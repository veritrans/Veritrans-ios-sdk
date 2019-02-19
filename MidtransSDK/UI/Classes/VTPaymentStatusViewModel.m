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
@property (nonatomic) MIDPaymentResult *transactionResult;
@end

@implementation VTPaymentStatusViewModel

- (instancetype)initWithTransactionResult:(MIDPaymentResult *)transactionResult {
    if (self = [super init]) {
        self.transactionResult = transactionResult;
        self.totalAmount = transactionResult.grossAmount.formattedCurrencyNumber;
        self.orderId = transactionResult.orderID;
        
        NSDateFormatter *formatter = [NSObject dateFormatterWithIdentifier:@"vt.date"];
        formatter.dateFormat = @"dd/MM/yyyy, HH:mm:ss";
        self.transactionTime = [formatter stringFromDate:transactionResult.transactionTime];
        NSString *paymentTypeString = [[NSString stringFromPaymentMethod:transactionResult.paymentMethod] stringByReplacingOccurrencesOfString:@"_" withString:@" "];
        self.paymentType = [paymentTypeString capitalizedString];
    }
    return self;
}

@end
