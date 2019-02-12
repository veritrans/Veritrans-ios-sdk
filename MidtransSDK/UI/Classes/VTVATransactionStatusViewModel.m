//
//  VTVATransactionStatusViewModel.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 5/20/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTVATransactionStatusViewModel.h"
#import <MidtransCoreKit/MidtransCoreKit.h>

@implementation VTVATransactionStatusViewModel

- (instancetype)initWithTransactionResult:(MidtransTransactionResult *)transactionResult
                        paymentIdentifier:(NSString *)paymentIdentifier {
    if (self = [super initWithTransactionResult:transactionResult]) {
        if ([paymentIdentifier isEqualToString:MIDTRANS_PAYMENT_ECHANNEL]) {
            self.billpayCode = transactionResult.mandiriBillpayCode;
            self.companyCode = transactionResult.mandiriBillpayCompanyCode;
        }
        else {
            self.vaNumber = transactionResult.virtualAccountNumber;
        }
    }
    return self;
}

@end
