//
//  MIdtransPaymentStatus.m
//  MidtransKit
//
//  Created by Arie on 10/31/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MIdtransPaymentStatusView.h"
#import <MidtransCoreKit/MidtransCoreKit.h>
#import "UIColor+VTColor.h"
#import "VTClassHelper.h"
@implementation MIdtransPaymentStatusView
- (void)configureWithTransactionResult:(MidtransTransactionResult *)result {
    if ([[result.additionalData objectForKey:@"fraud_status"] isEqualToString:@"challenge"]) {
        self.paymentStatusWrapperView.backgroundColor = [UIColor orangeColor];
        self.paymentStatusPaymentTypeLabel.text =  [[result.paymentType stringByReplacingOccurrencesOfString:@"_" withString:@" "] capitalizedString];
        NSDateFormatter *formatter = [NSObject dateFormatterWithIdentifier:@"vt.date"];
        formatter.dateFormat = @"dd/MM/yyyy, HH:mm:ss";
        self.paymentStatusTransactionTimeLabel.text = [formatter stringFromDate:result.transactionTime];
        self.paymentStatusOrderIdNumberLabel.text = result.orderId;
        self.paymentStatusTotalAmountLabel.text  = result.grossAmount.formattedCurrencyNumber;

    }
}

@end
