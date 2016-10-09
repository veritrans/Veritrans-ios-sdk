//
//  VTVATransactionStatusViewModel.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 5/20/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTVATransactionStatusViewModel.h"

@implementation VTVATransactionStatusViewModel
- (instancetype)initWithTransactionResult:(MidtransTransactionResult *)transactionResult vaType:(MidtransVAType)vaType {
    if (self = [super initWithTransactionResult:transactionResult]) {
        self.vaType = vaType;
        
        switch (vaType) {
            case VTVATypeMandiri: {
                self.billpayCode = transactionResult.mandiriBillpayCode;
                self.companyCode = transactionResult.mandiriBillpayCompanyCode;
                break;
            }
            case VTVATypeBCA:
            case VTVATypePermata:
            case  VTVATypeOther:
                self.vaNumber = transactionResult.virtualAccountNumber;
                break;
        }
        
    }
    return self;
}
@end
