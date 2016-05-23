//
//  VTVATransactionStatusViewModel.h
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 5/20/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTPaymentStatusViewModel.h"
#import "VTClassHelper.h"

@interface VTVATransactionStatusViewModel : VTPaymentStatusViewModel
@property (nonatomic) NSString *vaNumber;
@property (nonatomic, assign) VTVAType vaType;
- (instancetype)initWithTransactionResult:(VTTransactionResult *)transactionResult vaType:(VTVAType)vaType;
@end
