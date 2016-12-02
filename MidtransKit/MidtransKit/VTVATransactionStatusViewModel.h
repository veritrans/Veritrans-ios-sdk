//
//  VTVATransactionStatusViewModel.h
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 5/20/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTPaymentStatusViewModel.h"
#import "VTClassHelper.h"

#import <MidtransCoreKit/MidtransPaymentBankTransfer.h>

@interface VTVATransactionStatusViewModel : VTPaymentStatusViewModel

@property (nonatomic) NSString *vaNumber;
@property (nonatomic) NSString *billpayCode;
@property (nonatomic) NSString *companyCode;
@property (nonatomic, assign) MidtransVAType vaType;

- (instancetype)initWithTransactionResult:(MidtransTransactionResult *)transactionResult
                        paymentIdentifier:(NSString *)paymentIdentifier;

@end
