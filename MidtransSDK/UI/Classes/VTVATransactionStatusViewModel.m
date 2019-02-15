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

- (instancetype)initWithTransactionResult:(MIDPaymentResult *)transactionResult
                        paymentIdentifier:(NSString *)paymentIdentifier {
    
    if (self = [super initWithTransactionResult:transactionResult]) {
        if ([transactionResult isKindOfClass:[MIDMandiriBankTransferResult class]]) {
            MIDMandiriBankTransferResult *_result = (MIDMandiriBankTransferResult *)transactionResult;
            self.billpayCode = _result.key;
            self.companyCode = _result.code;
        }
        else if ([transactionResult isKindOfClass:[MIDBNIBankTransferResult class]]) {
            MIDBNIBankTransferResult *result = (MIDBNIBankTransferResult *)transactionResult;
            self.vaNumber = result.vaNumber;
        }
        else if ([transactionResult isKindOfClass:[MIDBCABankTransferResult class]]) {
            MIDBCABankTransferResult *result = (MIDBCABankTransferResult *)transactionResult;
            self.vaNumber = result.vaNumber;
        }
        else if ([transactionResult isKindOfClass:[MIDPermataBankTransferResult class]]) {
            MIDPermataBankTransferResult *result = (MIDPermataBankTransferResult *)transactionResult;
            self.vaNumber = result.vaNumber;
        }
    }
    return self;
}

@end
