//
//  MIdtransPaymentStatus.m
//  MidtransKit
//
//  Created by Arie on 10/31/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MIdtransPaymentStatusView.h"
#import "UIColor+VTColor.h"
#import "VTClassHelper.h"
@implementation MIdtransPaymentStatusView

- (void)configureWithTransactionResult:(MIDPaymentResult *)result {
    if ([result.fraudStatus isEqualToString:@"challenge"]) {
        self.paymentStatusWrapperView.backgroundColor = [UIColor orangeColor];
        self.paymentStatusPaymentTypeLabel.text =  [[[NSString stringOfPaymentMethod:result.paymentMethod] stringByReplacingOccurrencesOfString:@"_" withString:@" "] capitalizedString];
        NSDateFormatter *formatter = [NSObject dateFormatterWithIdentifier:@"vt.date"];
        formatter.dateFormat = @"dd/MM/yyyy, HH:mm:ss";
        self.paymentStatusTransactionTimeLabel.text = [formatter stringFromDate:result.transactionTime];
        self.paymentStatusOrderIdNumberLabel.text = result.orderID;
        self.paymentStatusTotalAmountLabel.text  = result.grossAmount.formattedCurrencyNumber;
    }
}

@end
