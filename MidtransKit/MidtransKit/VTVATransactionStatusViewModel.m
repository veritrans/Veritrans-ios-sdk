//
//  VTVATransactionStatusViewModel.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 5/20/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTVATransactionStatusViewModel.h"

@implementation VTVATransactionStatusViewModel
- (instancetype)initWithTransactionResult:(VTTransactionResult *)transactionResult vaType:(VTVAType)vaType {
    if (self = [super initWithTransactionResult:transactionResult]) {
        self.vaType = vaType;
        
        switch (vaType) {
            case VTVATypeBCA: {
                NSDictionary *vaData = transactionResult.additionalData[@"va_numbers"][0];
                self.vaNumber = vaData[@"va_number"];
                break;
            }
            case VTVATypePermata:
            case VTVATypeMandiri:
            case  VTVATypeOther:
                self.vaNumber = transactionResult.additionalData[@"permata_va_number"];
                break;
        }
        
    }
    return self;
}
@end
